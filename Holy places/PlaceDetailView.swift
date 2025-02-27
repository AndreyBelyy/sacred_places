import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    var onClose: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) { // ✅ Balanced spacing
            // 📸 Place Image with Side Padding
            AsyncImage(url: place.imageURL) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 16) // ✅ Added left & right padding
            .padding(.top, 10) // ✅ Balanced space from top

            // 📌 Place Info
            VStack(alignment: .leading, spacing: 12) {
                Text(place.name)
                    .font(.title3.bold())
                    .foregroundColor(.black)

                Text(place.category.localizedName)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(place.description)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.85))
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)

            // 🎯 Buttons Section
            VStack(spacing: 12) {
                if let sourceURL = place.sourceURL {
                    Button(action: { openURL(sourceURL) }) {
                        HStack {
                            Image(systemName: "book.fill")
                                .font(.system(size: 18))
                            Text("Read More")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.gradient)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 16)
                }

                Button(action: { openInMaps() }) {
                    HStack {
                        Image(systemName: "map.fill")
                            .font(.system(size: 18))
                        Text("Get Directions")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.gradient)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 16) // ✅ Restored bottom spacing
        }
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 12)
        .padding(.horizontal, 12)
        .padding(.bottom, 30)
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
