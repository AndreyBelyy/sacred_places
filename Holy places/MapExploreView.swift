import SwiftUI
import MapKit

struct MapExploreView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel = PlacesViewModel.shared
    @State private var selectedPlace: Place?

    var nearestPlaces: [Place] {
        guard let userLocation = locationManager.userLocation else { return [] }
        return viewModel.getNearestPlaces(to: userLocation.coordinate, limit: 10)
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )), annotationItems: nearestPlaces) { place in
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
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(5)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // Show Place Detail when a pin is tapped
            if let place = selectedPlace {
                PlaceDetailView(place: place)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedPlace)
                    .onTapGesture {
                        selectedPlace = nil
                    }
            }
        }
    }
}
