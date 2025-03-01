//
//  PlaceAnnotation.swift
//  Holy places
//
//  Created by Andrei Belyi on 01/03/25.
//


import MapKit

class PlaceAnnotation: NSObject, MKAnnotation, Identifiable {
    let id = UUID()  // ✅ Required for SwiftUI Map
    let place: Place
    var coordinate: CLLocationCoordinate2D { place.coordinate }
    var title: String? { place.name }

    init(place: Place) {
        self.place = place
    }
}
