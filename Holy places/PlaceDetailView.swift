import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    var onClose: (() -> Void)?
    var onDirections: (() -> Void)?  // ✅ Callback for opening Apple Maps

    var body: some View {
        VStack(spacing: 12) {
            // 📸 Place Image
            AsyncImage(url: place.imageURL) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)

            // 📝 Place Info
            VStack(alignment: .leading, spacing: 12) {
                Text(place.name)
                    .font(.title3.bold())

                Text(place.category.localizedName)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(place.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)

            // 🎯 Buttons
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
                    .padding(.horizontal, 16)
                }

                Button(action: {
                    onDirections?()  // ✅ Notify that Apple Maps is opened
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
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 16)
        }
        .frame(width: 350)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 12)
        .padding(.horizontal, 12)
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
