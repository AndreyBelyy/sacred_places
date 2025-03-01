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

    // ✅ Store current map position to prevent auto-reset
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964), // Default: Rome
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

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
            // ✅ Use `mapRegion` to keep position after closing place detail
            Map(coordinateRegion: $mapRegion, annotationItems: filteredPlaces) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    Button(action: {
                        selectedPlace = place
                        mapRegion.center = place.coordinate // ✅ Move map to selected place
                    }) {
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

            // 📌 **Show Place Detail in Center of Screen**
            if let place = selectedPlace {
                ZStack {
                    Color.black.opacity(0.3) // ✅ Dimmed background
                        .ignoresSafeArea()
                        .onTapGesture { selectedPlace = nil } // ✅ Tap outside to close

                    VStack {
                        Spacer()
                        PlaceDetailView(place: place, onClose: { selectedPlace = nil })
                        Spacer()
                    }
                }
                .transition(.opacity)
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
