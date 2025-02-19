//
//  FullNearbyPlacesListView.swift
//  Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//


import SwiftUI
import CoreLocation

struct FullNearbyPlacesListView: View {
    let places: [Place]
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationView {
            List(places) { place in
                NavigationLink(destination: PlaceDetailView(place: place)) {
                    PlaceRow(place: place)  // ✅ Fix: Remove 'userCoordinate' argument if not needed
                }
            }
            .navigationTitle("Nearby Places")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

