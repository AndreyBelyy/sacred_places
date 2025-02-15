//
// MapView.swift
// HolyPlacesApp
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = PlacesViewModel.shared
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 31.7683, longitude: 35.2137), // Jerusalem
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: viewModel.places) { place in
            MapAnnotation(coordinate: place.coordinate) {
                NavigationLink(destination: PlaceDetailView(place: place)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
        }
        .ignoresSafeArea()
    }
}
