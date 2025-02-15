//
// NearbyPlacesView.swift
// HolyPlacesApp
//

import SwiftUI
import CoreLocation

struct NearbyPlacesView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel = PlacesViewModel.shared
    @State private var nearestPlaces: [Place] = []
    @State private var numberOfPlaces = 3
    
    var body: some View {
        VStack {
            if let userLocation = locationManager.userLocation {
                Text("Your Location")
                    .font(.headline)
                
                Text(String(format: "Lat: %.4f, Lon: %.4f", userLocation.coordinate.latitude, userLocation.coordinate.longitude))
                    .font(.subheadline)
                
                Picker("Number of Nearby Places", selection: $numberOfPlaces) {
                    ForEach(1..<6) { num in
                        Text("\(num)").tag(num)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(nearestPlaces, id: \.id) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        Text("\(place.name) (\(String(format: "%.2f km", distanceBetween(userLocation.coordinate, place.coordinate))))")
                    }
                }
            } else {
                ProgressView("Fetching location...")
            }
        }
        .onAppear { updateNearestPlaces() }
        .onChange(of: locationManager.userLocation) { _ in updateNearestPlaces() }
    }
    
    private func updateNearestPlaces() {
        guard let userLocation = locationManager.userLocation else { return }
        nearestPlaces = viewModel.getNearestPlaces(to: userLocation.coordinate, limit: numberOfPlaces).map { $0 }
    }
}
