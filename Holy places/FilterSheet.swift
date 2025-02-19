import SwiftUI

struct FilterSheet: View {
    @Binding var selectedCategories: Set<HolyPlaceCategory>
    @Binding var selectedCountry: String?
    @Binding var selectedCity: String?

    @State private var cachedCities: [String: [String]] = [:]
    @State private var lastCacheUpdate: Date?

    private var allCountries: [String] {
        Array(Set(PlacesViewModel.shared.places.map { $0.country })).sorted()
    }

    private var allCities: [String] {
        guard let selectedCountry = selectedCountry else { return [] }
        return cachedCities[selectedCountry] ?? []
    }

    var body: some View {
        NavigationView {
            Form {
                // ✅ Category Selection
                Section(header: Text("Categories")) {
                    ForEach(HolyPlaceCategory.allCases, id: \.self) { category in
                        MultipleSelectionRow(
                            title: category.localizedName,
                            isSelected: selectedCategories.contains(category)
                        ) {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    }
                }

                // ✅ Country Selection
                Section(header: Text("Country")) {
                    Picker("Select Country", selection: $selectedCountry) {
                        Text("All").tag(nil as String?)
                        ForEach(allCountries, id: \.self) { country in
                            Text(country).tag(Optional(country))
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedCountry) { newCountry in
                        selectedCity = nil
                        if let country = newCountry {
                            fetchCities(for: country)
                        }
                    }
                }

                // ✅ City Selection (Only show cached cities)
                if selectedCountry != nil {
                    Section(header: Text("City")) {
                        Picker("Select City", selection: $selectedCity) {
                            Text("All").tag(nil as String?)
                            ForEach(allCities, id: \.self) { city in
                                Text(city).tag(Optional(city))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // ✅ Manual Cache Clearing
                Section {
                    Button(action: clearCache) {
                        Text("Clear Cache")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadCachedCities()
        }
    }

    private func loadCachedCities() {
        if let savedData = UserDefaults.standard.data(forKey: "cachedCities"),
           let decoded = try? JSONDecoder().decode([String: [String]].self, from: savedData) {
            cachedCities = decoded
        }

        if let lastUpdate = UserDefaults.standard.object(forKey: "cacheLastUpdate") as? Date {
            lastCacheUpdate = lastUpdate
        }
    }

    private func fetchCities(for country: String) {
        if let lastUpdate = lastCacheUpdate,
           Calendar.current.dateComponents([.day], from: lastUpdate, to: Date()).day ?? 0 < 21,
           let cached = cachedCities[country] {
            print("✅ Using cached cities for \(country)")
            return
        }

        let countryCities = Set(
            PlacesViewModel.shared.places
                .filter { $0.country == country }
                .compactMap { $0.city }
        )

        cachedCities[country] = Array(countryCities).sorted()
        lastCacheUpdate = Date()
        saveCachedCities()
    }

    private func saveCachedCities() {
        if let encoded = try? JSONEncoder().encode(cachedCities) {
            UserDefaults.standard.set(encoded, forKey: "cachedCities")
        }
        if let lastUpdate = lastCacheUpdate {
            UserDefaults.standard.set(lastUpdate, forKey: "cacheLastUpdate")
        }
    }

    private func clearCache() {
        UserDefaults.standard.removeObject(forKey: "cachedCities")
        UserDefaults.standard.removeObject(forKey: "cacheLastUpdate")
        cachedCities = [:]
        lastCacheUpdate = nil
        print("🗑️ Cache Cleared!")
    }

    @Environment(\.dismiss) private var dismiss
}

// ✅ Fix: Define `MultipleSelectionRow`
struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 5)
        }
    }
}
