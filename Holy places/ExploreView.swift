//
//  ExploreView.swift
//  Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//

import SwiftUI

struct ExploreView: View {
    @AppStorage("searchText") private var searchText = "" // ✅ Save search term
    @State private var selectedCity: String? = nil
    @State private var selectedCategory: HolyPlaceCategory? = nil

    @StateObject private var viewModel = PlacesViewModel.shared

    var filteredPlaces: [Place] {
        viewModel.places.filter { place in
            (searchText.isEmpty || place.name.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCity == nil || place.city == selectedCity) &&
            (selectedCategory == nil || place.category == selectedCategory)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // ✅ **Search Bar & Filters**
                VStack(spacing: 8) {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)

                    // 🔹 **Filter Buttons**
                    HStack(spacing: 10) {
                        // **City Filter**
                        Menu {
                            Button("All cities", action: { selectedCity = nil })
                            Divider()
                            ForEach(Set(viewModel.places.compactMap { $0.city }).sorted(), id: \.self) { city in
                                Button(city) { selectedCity = city }
                            }
                        } label: {
                            FilterButton(title: selectedCity ?? "All cities")
                        }

                        // **Category Filter**
                        Menu {
                            Button("All types", action: { selectedCategory = nil })
                            Divider()
                            ForEach(HolyPlaceCategory.allCases, id: \.self) { category in
                                Button(category.localizedName) { selectedCategory = category }
                            }
                        } label: {
                            FilterButton(title: selectedCategory?.localizedName ?? "All types")
                        }
                    }
                }
                .padding()
                .background(Color.white.shadow(radius: 3))

                // ✅ **List View**
                List(filteredPlaces) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        ExplorePlaceRow(place: place)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
//////////////////////////////////////
// MARK: - Custom Components
//////////////////////////////////////

// A custom search bar view.
struct SearchBar: View {
    @Binding var text: String  // Binding allows two-way data flow with the parent view.
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            // Text field for user input.
            TextField("Type a destination...", text: $text)
                .foregroundColor(.primary)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

// A custom tab button used for switching between "Stays" and "Near" tabs.
struct TabButton: View {
    let title: String               // Title to display on the button.
    @Binding var selectedTab: String // Binding to the parent's selected tab.
    let tabName: String             // The tab identifier.
    
    var body: some View {
        Button(action: { selectedTab = tabName }) {
            Text(title)
                // Change text color based on whether the tab is selected.
                .foregroundColor(selectedTab == tabName ? .red : .gray)
                // Bold font if the tab is selected.
                .fontWeight(selectedTab == tabName ? .bold : .regular)
        }
        .padding(.vertical, 8)
        // An underline indicator for the selected tab.
        .overlay(
            Rectangle()
                .frame(height: 2)
                .foregroundColor(selectedTab == tabName ? .red : .clear),
            alignment: .bottom
        )
    }
}

// A custom card view representing a place.
struct PlaceCard: View {
    let place: Place   // The place model to display.
    
    var body: some View {
        VStack {
            // Load an image asynchronously.
            AsyncImage(url: place.imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView() // Show a progress indicator while loading.
                }
            }
            .frame(width: 160, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
                Text(place.country)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
        }
        .frame(width: 160)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}
struct ExplorePlaceRow: View {
    let place: Place

    var body: some View {
        HStack {
            AsyncImage(url: place.imageURL) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Image(systemName: "photo") // ✅ Show placeholder if image fails
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("\(place.city ?? "Unknown City"), \(place.country ?? "Unknown Country")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}

struct FilterButton: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
            Image(systemName: "chevron.down")
        }
        .font(.callout)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}
