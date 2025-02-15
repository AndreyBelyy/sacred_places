import SwiftUI
import CoreLocation

// Enum for different categories of holy places
enum HolyPlaceCategory: String, CaseIterable {
    case monasteryComplexes = "monastery_complexes"
    case holySprings = "holy_springs"
    case apparitionSites = "apparition_sites"
    case holyRelics = "holy_relics"
    case crossParticles = "cross_particles"
    case miracleIcons = "miracle_icons"
    
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// Model for each holy place
struct Place: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let category: HolyPlaceCategory
    let coordinate: CLLocationCoordinate2D
    let description: String
    let imageURL: URL
}

class PlacesViewModel: ObservableObject {
    static let shared = PlacesViewModel()
    
    @Published var places: [Place] = [
        Place(
            name: "Tomb of Apostle Peter",
            country: "Vatican",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.9029, longitude: 12.4534),
            description: "A sacred site where the Apostle Peter is believed to be buried.",
            imageURL: URL(string: "https://cdn-imgix.headout.com/media/images/94a3b65db3e58bbf5121b4b82f8f2991-10479-rome-st.-peter-s-basilica-dome-guided-tour-with-optional-breakfast-06.jpg?auto=format&w=1222.3999999999999&h=687.6&q=90&fit=crop&ar=16%3A9&crop=faces")!
        ),
        Place(
            name: "Western Wall",
            country: "Israel",
            category: .apparitionSites,
            coordinate: CLLocationCoordinate2D(latitude: 31.7767, longitude: 35.2345),
            description: "A historic and sacred wall in Jerusalem.",
            imageURL: URL(string: "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcQ8ecPJSoBazgWR3nG0MJKpGXowagK4nlv0Rt-mMUtYT_YLcU7bEV1zgK7eARYqhwnv-tjYF4BRdKBClwbN3bFAis-F5vrLxxbHetIdZg")!
        )
    ]
    
    // Function to get places grouped by country and category
    var placesByCountry: [String: [HolyPlaceCategory: [Place]]] {
        Dictionary(grouping: places, by: { $0.country })
            .mapValues { places in
                Dictionary(grouping: places, by: { $0.category })
            }
    }
    
    // Function to find the nearest places to the user's location
    func getNearestPlaces(to coordinate: CLLocationCoordinate2D, limit: Int) -> [Place] {
        let sortedPlaces = places.sorted {
            distanceBetween($0.coordinate, coordinate) < distanceBetween($1.coordinate, coordinate)
        }
        return Array(sortedPlaces.prefix(limit))
    }
}

// Function to calculate distance between two coordinates (in km)
func distanceBetween(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> Double {
    let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
    let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
    return loc1.distance(from: loc2) / 1000 // Convert meters to km
}
