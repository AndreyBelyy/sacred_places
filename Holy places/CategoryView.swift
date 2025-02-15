import SwiftUI

struct CategoryView: View {
    let country: String
    @StateObject private var viewModel = PlacesViewModel.shared
    
    var body: some View {
        List(HolyPlaceCategory.allCases, id: \.self) { category in
            if let places = viewModel.placesByCountry[country]?[category], !places.isEmpty {
                NavigationLink(destination: PlacesListView(country: country, category: category)) {
                    Text(category.localizedName)
                        .font(.headline)
                        .padding()
                }
            }
        }
        .navigationTitle(country)
    }
}
