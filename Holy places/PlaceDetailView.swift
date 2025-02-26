import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    var onClose: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) { // ✅ Increased spacing between elements
            // 📸 Full-width Image
            AsyncImage(url: place.imageURL) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity) // ✅ Full-width
            .frame(height: 200) // ✅ Increased height for better visuals
            .clipShape(RoundedRectangle(cornerRadius: 20)) // ✅ Smooth rounded corners
            .padding(.horizontal) // ✅ Align with buttons

            // 📌 Place Info
            VStack(alignment: .leading, spacing: 10) { // ✅ More spacing
                Text(place.name)
                    .font(.title2.bold())
                    .foregroundColor(.black)

                Text(place.category.localizedName)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(place.description)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.85))
            }
            .padding(.horizontal)
            .padding(.bottom, 10) // ✅ Increased spacing before buttons

            // 🎯 Buttons Section
            VStack(spacing: 14) { // ✅ Even button spacing
                if let sourceURL = place.sourceURL {
                    Button(action: { openURL(sourceURL) }) {
                        HStack {
                            Image(systemName: "book.fill") // 📖 Book Icon
                                .font(.system(size: 18))
                            Text("Read More")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.gradient)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Button(action: { openInMaps() }) {
                    HStack {
                        Image(systemName: "map.fill") // 🗺️ Map Icon
                            .font(.system(size: 18))
                        Text("Get Directions")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.gradient)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12) // ✅ More bottom space
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 15)
        .padding(.horizontal)
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
