import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    var onClose: (() -> Void)?
    var onDirections: (() -> Void)?
    
    var body: some View {
            VStack(spacing: 0) {
                // 1) Load the image with no manual clipping
                AsyncImage(url: place.imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            // 2) Scale to fit so the whole image is visible
                            .scaledToFit()
                            // 3) Make it fill the card’s width
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                    }
                }

                // 4) Content below the image
                VStack(alignment: .leading, spacing: 12) {
                    Text(place.name)
                        .font(.title3.bold())
                    Text(place.category.localizedName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(place.description)
                        .font(.body)

                
                // Buttons, etc.
                VStack(spacing: 12) {
                    if let sourceURL = place.sourceURL {
                        Button(action: { openURL(sourceURL) }) {
                            HStack {
                                Image(systemName: "book.fill")
                                Text("Read More")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.gradient)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    
                    Button(action: {
                        onDirections?()
                        openInMaps()
                    }) {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Get Directions")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.gradient)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
            .padding(.all, 16)
        }
        // Make the whole VStack a rounded card
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 12)
        .padding(.horizontal, 12)
        .frame(width: 350)
    }
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    private func openInMaps() {
        let coordinate = place.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps()
    }
}
