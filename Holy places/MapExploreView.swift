import SwiftUI
import MapKit

struct MapExploreView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel = PlacesViewModel.shared

    @State private var selectedPlace: Place?
    @State private var showFilterSheet = false
    @State private var selectedCategories: Set<HolyPlaceCategory> = []
    @State private var selectedCountry: String? = nil
    @State private var selectedCity: String? = nil

    var filteredPlaces: [Place] {
        var places = viewModel.places

        if !selectedCategories.isEmpty {
            places = places.filter { selectedCategories.contains($0.category) }
        }
        if let country = selectedCountry {
            places = places.filter { $0.country == country }
        }
        if let city = selectedCity {
            places = places.filter { $0.city == city }
        }

        return places
    }

    var body: some View {
        ZStack(alignment: .top) {
            // 📍 Map with filtered places
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )), annotationItems: filteredPlaces) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    Button(action: { selectedPlace = place }) {
                        VStack(spacing: 5) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            
                            Text(place.name)
                                .font(.caption)
                                .bold()
                                .padding(5)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(5)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // 🎛 **Filter Button**
            HStack {
                Button(action: { showFilterSheet.toggle() }) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 4)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)

            // 📌 Show Place Detail when tapping a pin
            if let place = selectedPlace {
                PlaceDetailView(place: place, onClose: { selectedPlace = nil })
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedPlace)
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(
                selectedCategories: $selectedCategories,
                selectedCountry: $selectedCountry,
                selectedCity: $selectedCity
            )
        }
    }
}
