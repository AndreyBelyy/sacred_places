import SwiftUI

struct PlaceDetailView: View {
    let place: Place
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: place.imageURL) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
                
                Text(place.name)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                Text(place.category.localizedName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Divider()
                
                Text(place.description)
                    .font(.body)
                    .padding(.horizontal)
                
                if let sourceURL = place.sourceURL {
                    Button(action: {
                        openURL(sourceURL)
                    }) {
                        Text("Read More")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(place.name)
    }
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
