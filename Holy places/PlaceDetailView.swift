import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    
    var body: some View {
        ScrollView {
            AsyncImage(url: place.imageURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 250)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(place.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(place.country)
                    .font(.title3)
                    .foregroundColor(.secondary)

                Text(place.description)
                    .font(.body)
                    .padding(.vertical)
                
                Button(action: {
                    openInMaps(coordinate: place.coordinate)
                }) {
                    Text("Get Directions")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openInMaps(coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps()
    }
}
