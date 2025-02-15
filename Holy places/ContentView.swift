import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PlacesViewModel.shared
    
    var body: some View {
        NavigationView {
            List(viewModel.placesByCountry.keys.sorted(), id: \.self) { country in
                NavigationLink(destination: CategoryView(country: country)) {
                    Text(country)
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle(NSLocalizedString("explore_holy_places", comment: "Title for Holy Places"))
        }
    }
}
