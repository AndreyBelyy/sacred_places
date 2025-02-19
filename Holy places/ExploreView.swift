//
//  ExploreView.swift
//  Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//

import SwiftUI
import MapKit

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedTab = "stays"
    @State private var selectedPlace: Place? = nil
    @State private var showPreview = false
    @State private var showListView = false
    @State private var showFilterSheet = false
    
    @State private var selectedCategories: Set<HolyPlaceCategory> = []
    @State private var selectedCountry: String? = nil
    @State private var selectedCity: String? = nil
    @State private var sortAscending = true // ✅ Sort by distance
    
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel = PlacesViewModel.shared
    
    var nearestPlaces: [Place] {
        guard let userLocation = locationManager.userLocation else { return [] }
        
        var filteredPlaces = viewModel.places
        
        // ✅ Apply category filter
        if !selectedCategories.isEmpty {
            filteredPlaces = filteredPlaces.filter { selectedCategories.contains($0.category) }
        }
        
        // ✅ Apply country filter
        if let country = selectedCountry {
            filteredPlaces = filteredPlaces.filter { $0.country == country }
        }
        
        // ✅ Apply city filter
        if let city = selectedCity {
            filteredPlaces = filteredPlaces.filter { $0.city == city }
        }
        
        // ✅ Sort by proximity
        filteredPlaces.sort {
            let distance1 = calculateDistance(from: userLocation.coordinate, to: $0.coordinate)
            let distance2 = calculateDistance(from: userLocation.coordinate, to: $1.coordinate)
            return sortAscending ? distance1 < distance2 : distance1 > distance2
        }
        
        return Array(filteredPlaces.prefix(10))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: -10) {
                // ✅ Top Tab Selection
                HStack {
                    TabButton(title: "Stays", selectedTab: $selectedTab, tabName: "stays")
                    TabButton(title: "Near", selectedTab: $selectedTab, tabName: "near")
                }
                .padding(.top, 10)
                .background(Color.white)
                .zIndex(2)
                
                if selectedTab == "stays" {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Where would you like to travel?")
                            .font(.title.bold())
                            .padding(.horizontal)
                        
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(viewModel.places.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { place in
                                NavigationLink(destination: PlaceDetailView(place: place)) {
                                    PlaceCard(place: place)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    ZStack {
                        Map(
                            coordinateRegion: .constant(MKCoordinateRegion(
                                center: locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964),
                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            )),
                            annotationItems: nearestPlaces
                        ) { place in
                            MapAnnotation(coordinate: place.coordinate) {
                                Button(action: {
                                    selectedPlace = place
                                    showPreview = true
                                }) {
                                    VStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.title)
                                        
                                        Text(place.name)
                                            .font(.caption)
                                            .bold()
                                            .padding(5)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                        
                                        if let userLocation = locationManager.userLocation {
                                            let distance = calculateDistance(from: userLocation.coordinate, to: place.coordinate)
                                            Text("\(String(format: "%.1f km away", distance))")
                                                .font(.caption2)
                                                .foregroundColor(.black)
                                                .bold()
                                                .padding(3)
                                                .background(Color.white.opacity(0.8))
                                                .cornerRadius(3)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 450)
                        
                        if let place = selectedPlace {
                            PlacePreviewCard(place: place, isPresented: $showPreview, onViewDetails: {
                                showPreview = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedPlace = place // ✅ Ensure place is selected
                                }
                            })
                            .zIndex(3)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut)
                            
                            Color.black.opacity(0.001)
                                .onTapGesture {
                                    showPreview = false
                                    selectedPlace = nil
                                }
                        }
                        
                        VStack {
                            Spacer()
                            Button(action: { showListView = true }) {
                                Text("Show List View")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
            // ✅ **Attach the `.sheet(item:)` to `NavigationView`**
            .sheet(item: $selectedPlace) { place in
                PlaceDetailView(place: place)
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheet(selectedCategories: $selectedCategories, selectedCountry: $selectedCountry, selectedCity: $selectedCity)
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
