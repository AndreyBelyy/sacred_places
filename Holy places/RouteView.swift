//
// RouteView.swift
// HolyPlacesApp
//

import SwiftUI
import MapKit

struct RouteView: View {
    let place: Place
    
    var body: some View {
        VStack {
            Text("Route to \(place.name)")
                .font(.title2)
                .padding()
            
            Button(action: {
                openInAppleMaps(to: place.coordinate)
            }) {
                Text("Open in Apple Maps")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func openInAppleMaps(to coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps()
    }
}
