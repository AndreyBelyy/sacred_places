import SwiftUI

struct PlacesListView: View {
    let country: String
    let category: HolyPlaceCategory
    @StateObject private var viewModel = PlacesViewModel.shared
    
    var body: some View {
        List(viewModel.placesByCountry[country]?[category] ?? []) { place in
            NavigationLink(destination: PlaceDetailView(place: place)) {
                PlaceRow(place: place)
            }
        }
        .navigationTitle(category.localizedName)
    }
}

// 🔹 Custom Place Row (Fixed Image Loading)
struct PlaceRow: View {
    let place: Place
    
    var body: some View {
        HStack {
            AsyncImage(url: place.imageURL) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "photo") // Fallback image
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
            }
        }
    }
}
