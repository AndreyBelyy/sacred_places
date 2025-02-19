import SwiftUI

struct CountriesView: View {
    @StateObject private var viewModel = PlacesViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("explore_holy_places", comment: "Title for Holy Places"))
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(viewModel.placesByCountry.keys.sorted(), id: \.self) { country in
                            NavigationLink(destination: CategoryView(country: country)) {
                                CountryCard(country: country)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// 🔹 Custom Country Card
struct CountryCard: View {
    let country: String

    var body: some View {
        VStack {
            Image(systemName: "globe") // Placeholder, replace with actual images
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()

            Text(country)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 10)
        }
        .frame(width: 160, height: 180)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}
