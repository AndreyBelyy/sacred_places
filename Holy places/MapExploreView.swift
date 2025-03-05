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
    @State private var returningFromMaps = false  // ✅ Track if user returns from Apple Maps

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
        ZStack(alignment: .topTrailing) {
            // 📍 Clustered Map View
            ClusteredMapView(selectedPlace: $selectedPlace, places: filteredPlaces)
                .ignoresSafeArea()
                .onAppear {
                    if returningFromMaps {
                        returningFromMaps = false  // ✅ Reset when user returns from Apple Maps
                    }
                }

            // 🎛 Filter Button - pinned to top right
            Button(action: { showFilterSheet.toggle() }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Filters")
                }
                .padding(12)
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4)
            }
            .padding(.top, 16)
            .padding(.trailing, 16)

            // 📌 Centered Place Detail View
            if let place = selectedPlace {
                ZStack {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { selectedPlace = nil }

                    PlaceDetailView(
                        place: place,
                        onClose: { selectedPlace = nil },
                        onDirections: { returningFromMaps = true } // ✅ Notify when opening Apple Maps
                    )
                    .frame(maxWidth: 350)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                }
                .transition(.scale)
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
