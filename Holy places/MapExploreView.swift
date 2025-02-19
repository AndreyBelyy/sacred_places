//
//  MapExploreView.swift
//  Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//


import SwiftUI
import MapKit

struct MapExploreView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel = PlacesViewModel.shared
    
    var nearestPlaces: [Place] {
        guard let userLocation = locationManager.userLocation else { return [] }
        return viewModel.getNearestPlaces(to: userLocation.coordinate, limit: 10)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Map View
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 31.778333, longitude: 35.229722),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )), annotationItems: nearestPlaces) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            
                            Text("\(place.name)")
                                .font(.caption)
                                .bold()
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(5)
                        }
                    }
                }
                .ignoresSafeArea()
                
                // List of Nearby Places
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(nearestPlaces) { place in
                            NavigationLink(destination: PlaceDetailView(place: place)) {
                                PlaceCard(place: place)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
            }
        }
    }
}
