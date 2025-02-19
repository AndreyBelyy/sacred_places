import SwiftUI
import CoreLocation

// Enum for different categories of holy places
enum HolyPlaceCategory: String, CaseIterable {
    case monasteryComplexes = "Monastery Complexes"
    case holySprings = "Holy Springs"
    case apparitionSites = "Apparition Sites"
    case holyRelics = "Holy Relics"
    case crossParticles = "Cross Particles"
    case miracleIcons = "Miracle Icons"
    case relicsOfTheSaints = "Relics of the Saints"
    
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct Place: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let city: String? // ✅ Added city field
    let category: HolyPlaceCategory
    let coordinate: CLLocationCoordinate2D
    let description: String
    let imageURL: URL
    let sourceURL: URL? // ✅ Authority source for more info

    // ✅ Conform to `Hashable`
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
}

class PlacesViewModel: ObservableObject {
    static let shared = PlacesViewModel()
    
    @Published var places: [Place] = [
        // 1) Mount Athos – nearest port town Ouranoupoli in Greece
        Place(
            name: "Mount Athos",
            country: "Greece",
            city: "Ouranoupoli",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 40.1667, longitude: 24.3269),
            description: "A sacred mountain with 20 monasteries, a center of Orthodox spirituality.",
            imageURL: URL(string: "https://pravoslavie.ru/sas/image/103639/363964.p.jpg?mtime=1625230084")!,
            sourceURL: URL(string: "https://www.oxfordreference.com/display/10.1093/oi/authority.20110803095431707")!
        ),
        // 2) Monastery of St. Catherine – located near Saint Catherine in Egypt
        Place(
            name: "Monastery of St. Catherine",
            country: "Egypt",
            city: "Saint Catherine",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 28.5555, longitude: 33.9750),
            description: "One of the world's oldest Christian monasteries, located at the foot of Mount Sinai.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d9/St_Catherine%27s_Monastery_Sinai_Egypt.jpg")!,
            sourceURL: URL(string: "https://www.cambridge.org/core/books/sources-for-byzantine-art-history/greekgeorgian-inscription-king-david-the-builder-and-the-monastery-of-st-catherine-on-mount-sinai/A821A1F60CCCBA16FF97967023AC8EB4")!
        ),
        // 3) Kyiv Pechersk Lavra – located in Kyiv, Ukraine
        Place(
            name: "Kyiv Pechersk Lavra",
            country: "Ukraine",
            city: "Kyiv",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 50.4346, longitude: 30.5577),
            description: "A major Orthodox monastery known for its caves and religious relics.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Kiev_Pechersk_Lavra_15.JPG")!,
            sourceURL: URL(string: "https://www.rsl.ru/")!
        ),
        // 4) Trinity Lavra of St. Sergius – in Sergiyev Posad, Russia
        Place(
            name: "Trinity Lavra of St. Sergius",
            country: "Russia",
            city: "Sergiyev Posad",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 56.3151, longitude: 38.1365),
            description: "The most important monastery in Russia, founded by St. Sergius of Radonezh.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/37/Sergiyev_Posad_Lavra_04-2016_img06_Trinity_Cathedral.jpg")!,
            sourceURL: URL(string: "https://www.rsl.ru/")!
        ),
        // 5) Ostrog Monastery – near the village of Ostrog in Montenegro
        Place(
            name: "Ostrog Monastery",
            country: "Montenegro",
            city: "Ostrog",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 42.6755, longitude: 19.0294),
            description: "A stunning Orthodox monastery built into a cliffside, famous for miracles.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Ostrog_monastery.jpg")!,
            sourceURL: URL(string: "https://www.loc.gov/")!
        ),
        // 6) Monastery of St. Naum – near Ohrid in North Macedonia
        Place(
            name: "Monastery of St. Naum",
            country: "North Macedonia",
            city: "Ohrid",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 40.9235, longitude: 20.7408),
            description: "A peaceful monastery on Lake Ohrid, with relics of St. Naum.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Monastery_Saint_Naum.jpg")!,
            sourceURL: URL(string: "https://www.cambridge.org/core")!
        ),
        // 7) Valaam Monastery – located on Valaam Island, near Sortavala in Russia
        Place(
            name: "Valaam Monastery",
            country: "Russia",
            city: "Sortavala",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 61.3747, longitude: 30.9472),
            description: "A historic monastery located on an island in Lake Ladoga.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/85/Valaam_transfiguration.jpg")!,
            sourceURL: URL(string: "https://www.rsl.ru/")!
        ),
        // 8) Holy Trinity Cathedral – located in Tbilisi, Georgia
        Place(
            name: "Holy Trinity Cathedral",
            country: "Georgia",
            city: "Tbilisi",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.6938, longitude: 44.8014),
            description: "The largest Orthodox church in Georgia, located in Tbilisi.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Holy_Trinity_Cathedral_of_Tbilisi%2C_2016.jpg")!,
            sourceURL: URL(string: "https://www.oxfordreference.com/display/10.1093/oi/authority.20110803100231521")!
        ),
        // 9) Saint Nicholas Church (Bari, Italy) – located in Bari
        Place(
            name: "Saint Nicholas Church (Bari, Italy)",
            country: "Italy",
            city: "Bari",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.1256, longitude: 16.8719),
            description: "Holds the relics of St. Nicholas, a major pilgrimage site.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/65/Basilica_di_San_Nicola_Bari.jpg")!,
            sourceURL: URL(string: "https://www.oxfordreference.com/view/10.1093/oi/authority.20110803095430775")!
        ),
        // 10) Dormition Cathedral (Kazan, Russia) – in Kazan
        Place(
            name: "Dormition Cathedral (Kazan, Russia)",
            country: "Russia",
            city: "Kazan",
            category: .miracleIcons,
            coordinate: CLLocationCoordinate2D(latitude: 55.7961, longitude: 49.1082),
            description: "Home of the famous Kazan Icon of the Mother of God.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/19/KazanKremlCathedral.jpg")!,
            sourceURL: URL(string: "https://www.rsl.ru/")!
        ),
        // 11) Tomb of Apostle Peter – located in Vatican City
        Place(
            name: "Tomb of Apostle Peter",
            country: "Vatican",
            city: "Vatican City",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.9029, longitude: 12.4534),
            description: "A sacred site where the Apostle Peter is believed to be buried.",
            imageURL: URL(string: "https://cdn-imgix.headout.com/media/images/94a3b65db3e58bbf5121b4b82f8f2991-10479-rome-st.-peter-s-basilica-dome-guided-tour-with-optional-breakfast-06.jpg")!,
            sourceURL: URL(string: "https://www.loc.gov/")!
        ),
        // 12) Basilica of St. Clement – in Rome
        Place(
            name: "Basilica of St. Clement",
            country: "Italy",
            city: "Rome",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8892, longitude: 12.4974),
            description: "An ancient church with early Christian frescoes and relics.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3e/San_Clemente_al_Laterano.jpg")!,
            sourceURL: URL(string: "https://www.cambridge.org/core")!
        ),
        // 13) Basilica of St. Paul Outside the Walls – in Rome
        Place(
            name: "Basilica of St. Paul Outside the Walls",
            country: "Italy",
            city: "Rome",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8588, longitude: 12.4760),
            description: "Built over the tomb of Apostle Paul, one of the four papal basilicas.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/16/Basilica_San_Paolo.jpg")!,
            sourceURL: URL(string: "https://www.cambridge.org/core")!
        ),
        // 14) Basilica of Santa Maria in Cosmedin – in Rome
        Place(
            name: "Basilica of Santa Maria in Cosmedin",
            country: "Italy",
            city: "Rome",
            category: .miracleIcons,
            coordinate: CLLocationCoordinate2D(latitude: 41.8887, longitude: 12.4815),
            description: "A Greek Orthodox heritage church, famous for the 'Mouth of Truth'.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/aa/Santa_Maria_in_Cosmedin_Roma_1.jpg")!,
            sourceURL: URL(string: "https://www.oxfordreference.com/")!
        ),
        // 15) Church of St. Anthony the Great – in Rome
        Place(
            name: "Church of St. Anthony the Great",
            country: "Italy",
            city: "Rome",
            category: .monasteryComplexes,
            coordinate: CLLocationCoordinate2D(latitude: 41.8951, longitude: 12.4983),
            description: "A Russian Orthodox church in Rome, serving the Orthodox community.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/df/Sant%27Antonio_Abate_all%27Esquilino.jpg")!,
            sourceURL: URL(string: "https://www.oxfordreference.com/")!
        ),
        // 16) Catacombs of St. Domitilla – in Rome
        Place(
            name: "Catacombs of St. Domitilla",
            country: "Italy",
            city: "Rome",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8554, longitude: 12.5065),
            description: "An underground burial site with early Christian relics and artwork.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/03/Domitilla_catacombs.jpg")!,
            sourceURL: URL(string: "https://www.loc.gov/")!
        ),
        // 17) Catacombs of St. Sebastian – in Rome
        Place(
            name: "Catacombs of St. Sebastian",
            country: "Italy",
            city: "Rome",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8567, longitude: 12.5100),
            description: "The burial site of St. Sebastian, an early Christian martyr.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3c/San_Sebastiano_catacombs.jpg")!,
            sourceURL: URL(string: "https://www.loc.gov/")!
        ),
        // 18) Church of St. Catherine of Alexandria – in Rome
        Place(
            name: "Church of St. Catherine of Alexandria",
            country: "Italy",
            city: "Rome",
            category: .miracleIcons,
            coordinate: CLLocationCoordinate2D(latitude: 41.8976, longitude: 12.4802),
            description: "A Russian Orthodox Church near Piazza Venezia.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e8/Chiesa_di_Santa_Caterina_alexandria_Roma.jpg")!,
            sourceURL: URL(string: "https://www.cambridge.org/core")!
        ),
        // 19) Church of St. Nicholas (San Nicola in Carcere) – in Rome
        Place(
            name: "Church of St. Nicholas (San Nicola in Carcere)",
            country: "Italy",
            city: "Rome",
            category: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8923, longitude: 12.4791),
            description: "A historic church built over ancient Roman temples, dedicated to St. Nicholas.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/80/San_Nicola_in_Carcere_Rome.jpg")!,
            sourceURL: URL(string: "https://www.cambridge.org/core")!
        ),
        // 20) Western Wall – in Jerusalem
        Place(
            name: "Western Wall",
            country: "Israel",
            city: "Jerusalem",
            category: .apparitionSites,
            coordinate: CLLocationCoordinate2D(latitude: 31.7767, longitude: 35.2345),
            description: "A historic and sacred wall in Jerusalem.",
            imageURL: URL(string: "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcQ8ecPJSoBazgWR3nG0MJKpGXowagK4nlv0Rt-mMUtYT_YLcU7bEV1zgK7eARYqhwnv-tjYF4BRdKBClwbN3bFAis-F5vrLxxbHetIdZg")!,
            sourceURL: URL(string: "https://www.loc.gov/")!
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
// ✅ Distance Calculation Function
func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
    
    return fromLocation.distance(from: toLocation) / 1000 // Convert meters to kilometers
}
