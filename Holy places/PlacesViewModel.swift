import SwiftUI
import CoreLocation

// 🔹 Main categories of holy places
enum HolyPlaceCategory: String, CaseIterable {
    case monasteryComplexes = "Monastery Complexes"
    case churches = "Churches"  // ✅ Churches include relics, icons, etc.
    case holySprings = "Holy Springs"
    case apparitionSites = "Apparition Sites"

    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// 🔹 Subcategories for Churches (Relics, Icons, Particles)
enum ChurchSubcategory: String, CaseIterable {
    case generalChurch = "General Church"
    case holyRelics = "Holy Relics"
    case crossParticles = "Cross Particles"
    case miracleIcons = "Miracle Icons"

    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct Place: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let city: String?
    let category: HolyPlaceCategory
    let subcategory: ChurchSubcategory? // ✅ Only used for churches
    let coordinate: CLLocationCoordinate2D
    let description: String
    let imageURL: URL
    let sourceURL: URL?

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
        // 1. Mount Athos – Greece, Ouranoupoli
        Place(
            name: "Mount Athos",
            country: "Greece",
            city: "Ouranoupoli",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1667, longitude: 24.3269),
            description: "A sacred mountain with 20 monasteries, a center of Orthodox spirituality.",
            imageURL: URL(string: "https://pravoslavie.ru/sas/image/103639/363964.p.jpg?mtime=1625230084")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 2. Monastery of St. Catherine – Egypt, Saint Catherine
        Place(
            name: "Monastery of St. Catherine",
            country: "Egypt",
            city: "Saint Catherine",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 28.5555, longitude: 33.9750),
            description: "One of the world's oldest Christian monasteries, located at the foot of Mount Sinai.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d9/St_Catherine%27s_Monastery_Sinai_Egypt.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 3. Kyiv Pechersk Lavra – Ukraine, Kyiv
        Place(
            name: "Kyiv Pechersk Lavra",
            country: "Ukraine",
            city: "Kyiv",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 50.4346, longitude: 30.5577),
            description: "A major Orthodox monastery known for its network of caves and relics.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Kiev_Pechersk_Lavra_15.JPG")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 4. Trinity Lavra of St. Sergius – Russia, Sergiyev Posad
        Place(
            name: "Trinity Lavra of St. Sergius",
            country: "Russia",
            city: "Sergiyev Posad",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 56.3151, longitude: 38.1365),
            description: "The most important monastery in Russia, founded by St. Sergius of Radonezh.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/37/Sergiyev_Posad_Lavra_04-2016_img06_Trinity_Cathedral.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 5. Ostrog Monastery – Montenegro, Ostrog
        Place(
            name: "Ostrog Monastery",
            country: "Montenegro",
            city: "Ostrog",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 42.6755, longitude: 19.0294),
            description: "A remarkable monastery built into a vertical cliff, known for miracles.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Ostrog_monastery.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 6. Monastery of St. Naum – North Macedonia, Ohrid
        Place(
            name: "Monastery of St. Naum",
            country: "North Macedonia",
            city: "Ohrid",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.9235, longitude: 20.7408),
            description: "A serene monastery on the shores of Lake Ohrid, home to sacred relics.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Monastery_Saint_Naum.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 7. Valaam Monastery – Russia, Sortavala
        Place(
            name: "Valaam Monastery",
            country: "Russia",
            city: "Sortavala",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 61.3747, longitude: 30.9472),
            description: "A historic monastery on an island in Lake Ladoga, known for its spiritual legacy.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/85/Valaam_transfiguration.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 8. Holy Trinity Cathedral – Georgia, Tbilisi
        Place(
            name: "Holy Trinity Cathedral",
            country: "Georgia",
            city: "Tbilisi",
            category: .churches,
            subcategory: .holyRelics, // Subcategory is Holy Relics
            coordinate: CLLocationCoordinate2D(latitude: 41.6938, longitude: 44.8014),
            description: "The largest Orthodox church in Georgia and a major pilgrimage site.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Holy_Trinity_Cathedral_of_Tbilisi%2C_2016.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")
        ),
        // 9. Saint Nicholas Church – Italy, Bari
        Place(
            name: "Saint Nicholas Church",
            country: "Italy",
            city: "Bari",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.1256, longitude: 16.8719),
            description: "A historic church that houses the relics of St. Nicholas.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/65/Basilica_di_San_Nicola_Bari.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 10. Dormition Cathedral – Russia, Kazan
        Place(
            name: "Dormition Cathedral",
            country: "Russia",
            city: "Kazan",
            category: .churches,
            subcategory: .miracleIcons,
            coordinate: CLLocationCoordinate2D(latitude: 55.7961, longitude: 49.1082),
            description: "Famed for the Kazan Icon of the Mother of God, a miraculous representation.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/19/KazanKremlCathedral.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 11. Tomb of Apostle Peter – Vatican City, Vatican
        Place(
            name: "Tomb of Apostle Peter",
            country: "Vatican City",
            city: "Vatican",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.9029, longitude: 12.4534),
            description: "The revered burial site of Apostle Peter, a key pilgrimage destination.",
            imageURL: URL(string: "https://cdn-imgix.headout.com/media/images/94a3b65db3e58bbf5121b4b82f8f2991-10479-rome-st.-peter-s-basilica-dome-guided-tour-with-optional-breakfast-06.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 12. Basilica of St. Clement – Italy, Rome
        Place(
            name: "Basilica of St. Clement",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8892, longitude: 12.4974),
            description: "An ancient basilica featuring early Christian frescoes and relics.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3e/San_Clemente_al_Laterano.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 13. Basilica of St. Paul Outside the Walls – Italy, Rome
        Place(
            name: "Basilica of St. Paul Outside the Walls",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8588, longitude: 12.4760),
            description: "Built over the tomb of Apostle Paul, a marvel of Christian architecture.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/16/Basilica_San_Paolo.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 14. Basilica of Santa Maria in Cosmedin – Italy, Rome
        Place(
            name: "Basilica of Santa Maria in Cosmedin",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .miracleIcons,
            coordinate: CLLocationCoordinate2D(latitude: 41.8887, longitude: 12.4815),
            description: "Known for the 'Mouth of Truth' and its rich Orthodox heritage.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/aa/Santa_Maria_in_Cosmedin_Roma_1.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 15. Church of St. Anthony the Great – Italy, Rome
        Place(
            name: "Church of St. Anthony the Great",
            country: "Italy",
            city: "Rome",
            category: .monasteryComplexes,
            subcategory: nil, // The user had it as a "monastery" in the original
            coordinate: CLLocationCoordinate2D(latitude: 41.8951, longitude: 12.4983),
            description: "A prominent Russian Orthodox church serving the local community in Rome.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/df/Sant%27Antonio_Abate_all%27Esquilino.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 16. Catacombs of St. Domitilla – Italy, Rome
        Place(
            name: "Catacombs of St. Domitilla",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8554, longitude: 12.5065),
            description: "Ancient catacombs housing early Christian relics and art.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/03/Domitilla_catacombs.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 17. Catacombs of St. Sebastian – Italy, Rome
        Place(
            name: "Catacombs of St. Sebastian",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8567, longitude: 12.5100),
            description: "The resting place of St. Sebastian, an emblem of early Christian martyrdom.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3c/San_Sebastiano_catacombs.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 18. Church of St. Catherine of Alexandria – Italy, Rome
        Place(
            name: "Church of St. Catherine of Alexandria",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .miracleIcons,
            coordinate: CLLocationCoordinate2D(latitude: 41.8976, longitude: 12.4802),
            description: "A Russian Orthodox church noted for its historic and miraculous legacy.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e8/Chiesa_di_Santa_Caterina_alexandria_Roma.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 19. Church of St. Nicholas (San Nicola in Carcere) – Italy, Rome
        Place(
            name: "Church of St. Nicholas (San Nicola in Carcere)",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.8923, longitude: 12.4791),
            description: "A historic church built over ancient Roman temples, dedicated to St. Nicholas.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/80/San_Nicola_in_Carcere_Rome.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 20. Western Wall – Israel, Jerusalem
        Place(
            name: "Western Wall",
            country: "Israel",
            city: "Jerusalem",
            category: .apparitionSites,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 31.7767, longitude: 35.2345),
            description: "A revered wall in Jerusalem, symbolizing ancient Jewish and Christian faith.",
            imageURL: URL(string: "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcQ8ecPJSoBazgWR3nG0MJKpGXowagK4nlv0Rt-mMUtYT_YLcU7bEV1zgK7eARYqhwnv-tjYF4BRdKBClwbN3bFAis-F5vrLxxbHetIdZg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 21. Hilandar Monastery – Greece, Mount Athos
        Place(
            name: "Hilandar Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1234, longitude: 24.3000),
            description: "A Serbian monastery on Mount Athos, rich in spiritual tradition.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 22. Vatopedi Monastery – Greece, Mount Athos
        Place(
            name: "Vatopedi Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1419, longitude: 24.3361),
            description: "One of the largest and most revered monasteries on Mount Athos.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 23. Great Lavra – Greece, Mount Athos
        Place(
            name: "Great Lavra",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1531, longitude: 24.3333),
            description: "The oldest and largest monastery on Mount Athos, a spiritual beacon.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 24. Simonopetra Monastery – Greece, Mount Athos
        Place(
            name: "Simonopetra Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1600, longitude: 24.3500),
            description: "A stunning monastery perched on a cliffside at Mount Athos.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 25. Xenophontos Monastery – Greece, Mount Athos
        Place(
            name: "Xenophontos Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1550, longitude: 24.3400),
            description: "A remote monastery on Mount Athos, noted for its ancient manuscripts.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 26. Iviron Monastery – Greece, Mount Athos
        Place(
            name: "Iviron Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.2000, longitude: 24.3500),
            description: "Founded by Georgian monks, a center of Orthodox culture on Athos.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 27. Koutloumousiou Monastery – Greece, Mount Athos
        Place(
            name: "Koutloumousiou Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1700, longitude: 24.3200),
            description: "A historic monastery on Mount Athos known for its icon collection.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 28. Esphigmenou Monastery – Greece, Mount Athos
        Place(
            name: "Esphigmenou Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 40.1800, longitude: 24.3600),
            description: "One of the most isolated and austere monasteries on Mount Athos.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 29. Solovetsky Monastery – Russia, Solovki
        Place(
            name: "Solovetsky Monastery",
            country: "Russia",
            city: "Solovki",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 63.5, longitude: 35.1),
            description: "A historic monastic complex on the Solovetsky Islands, steeped in legend.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 30. Pskovo-Pechersky Monastery – Russia, Pskov
        Place(
            name: "Pskovo-Pechersky Monastery",
            country: "Russia",
            city: "Pskov",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 57.8833, longitude: 28.3167),
            description: "Renowned for its cave churches and ancient relics.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 31. Pochaev Lavra – Ukraine, Pochaev
        Place(
            name: "Pochaev Lavra",
            country: "Ukraine",
            city: "Pochaev",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 50.0167, longitude: 25.9333),
            description: "A major Ukrainian Orthodox monastery known for its miraculous icons.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 32. Svetitskhoveli Cathedral – Georgia, Mtskheta
        Place(
            name: "Svetitskhoveli Cathedral",
            country: "Georgia",
            city: "Mtskheta",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.9022, longitude: 44.7216),
            description: "A UNESCO World Heritage site and an important Georgian pilgrimage destination.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/09/Svetitskhoveli_Cathedral.jpg")!,
            sourceURL: URL(string: "https://ortodossia.org/svyatyni/")!
        ),
        // 33. Gelati Monastery – Georgia, Kutaisi
        Place(
            name: "Gelati Monastery",
            country: "Georgia",
            city: "Kutaisi",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 42.2500, longitude: 42.7000),
            description: "A medieval monastic complex famed for its mosaics and frescoes.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/30/Gelati_Monastery.jpg")!,
            sourceURL: URL(string: "https://ortodossia.org/svyatyni/")!
        ),
        // 34. Alaverdi Monastery – Georgia, Kvareli
        Place(
            name: "Alaverdi Monastery",
            country: "Georgia",
            city: "Kvareli",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 42.0000, longitude: 44.8000),
            description: "An ancient monastery still active in the Georgian Orthodox Church.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/80/Alaverdi_Monastery.jpg")!,
            sourceURL: URL(string: "https://ortodossia.org/svyatyni/")!
        ),
        // 35. Rila Monastery – Bulgaria, Rila
        Place(
            name: "Rila Monastery",
            country: "Bulgaria",
            city: "Rila",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 42.1333, longitude: 23.3333),
            description: "Bulgaria's largest and most famous monastery, a masterpiece of Bulgarian Renaissance.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1b/Rila_Monastery.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 36. Rozhen Monastery – Bulgaria, Rozhen
        Place(
            name: "Rozhen Monastery",
            country: "Bulgaria",
            city: "Rozhen",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 41.8833, longitude: 23.7167),
            description: "A lesser-known but spiritually significant monastery in Bulgaria.",
            imageURL: URL(string: "https://azbyka.ru/palomnik/")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 37. Studenica Monastery – Serbia, Studenica
        Place(
            name: "Studenica Monastery",
            country: "Serbia",
            city: "Studenica",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 43.0333, longitude: 20.4167),
            description: "One of Serbia's most important monasteries, rich in medieval art.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3b/Studenica_Monastery.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 38. Žiča Monastery – Serbia, Kraljevo
        Place(
            name: "Žiča Monastery",
            country: "Serbia",
            city: "Kraljevo",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 43.4000, longitude: 21.1000),
            description: "A historic monastery that played a central role in Serbian medieval history.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/00/Zica_Monastery.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 39. Curtea de Argeș Monastery – Romania, Curtea de Argeș
        Place(
            name: "Curtea de Argeș Monastery",
            country: "Romania",
            city: "Curtea de Argeș",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 45.1000, longitude: 24.5167),
            description: "A significant Romanian Orthodox monastery known for its architecture and legends.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/4f/Curtea_de_Arges_Monastery.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 40. Voroneț Monastery – Romania, Voroneț
        Place(
            name: "Voroneț Monastery",
            country: "Romania",
            city: "Voroneț",
            category: .monasteryComplexes,
            subcategory: nil,
            coordinate: CLLocationCoordinate2D(latitude: 47.7167, longitude: 26.3000),
            description: "Famous for its vivid frescoes and nicknamed the 'Sistine Chapel of the East'.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/24/Voronet_Monastery.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 41. Church of Saint Barnabas – Cyprus, Famagusta
        Place(
            name: "Church of Saint Barnabas",
            country: "Cyprus",
            city: "Famagusta",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 35.1833, longitude: 33.3667),
            description: "A revered site associated with the apostle Barnabas, attracting pilgrims.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/93/Saint_Barnabas_Church_Cyprus.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 42. Church of St. George – Albania, Tirana
        Place(
            name: "Church of St. George",
            country: "Albania",
            city: "Tirana",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 41.3275, longitude: 19.8189),
            description: "An important center of Orthodox worship in Albania.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/5d/Church_of_St._George_Tirana.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 43. Warsaw Orthodox Cathedral – Poland, Warsaw
        Place(
            name: "Warsaw Orthodox Cathedral",
            country: "Poland",
            city: "Warsaw",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 52.2333, longitude: 21.0167),
            description: "A prominent center of Orthodox faith in Poland's capital.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/a0/Warsaw_Orthodox_Cathedral.jpg")!,
            sourceURL: URL(string: "https://ru.wikipedia.org/wiki/Христианские_реликивии")!
        ),
        // 44. Orthodox Church of the Czech Lands and Slovakia – Czech Republic, Prague
        Place(
            name: "Orthodox Church of the Czech Lands and Slovakia",
            country: "Czech Republic",
            city: "Prague",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378),
            description: "A modern center for Orthodox worship in the heart of Prague.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/70/Orthodox_Church_Prague.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 45. Holy Trinity Russian Orthodox Cathedral – USA, New York
        Place(
            name: "Holy Trinity Russian Orthodox Cathedral",
            country: "USA",
            city: "New York",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            description: "A major center of Russian Orthodoxy in New York City.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/8e/Holy_Trinity_Russian_Orthodox_Cathedral_NYC.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 46. St. Nicholas Russian Orthodox Cathedral – USA, Washington, D.C.
        Place(
            name: "St. Nicholas Russian Orthodox Cathedral",
            country: "USA",
            city: "Washington, D.C.",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 38.8951, longitude: -77.0364),
            description: "An architectural gem and spiritual center in the U.S. capital.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/31/St._Nicholas_Cathedral_Washington.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 47. Russian Orthodox Church of St. John the Baptist – Canada, Toronto
        Place(
            name: "Russian Orthodox Church of St. John the Baptist",
            country: "Canada",
            city: "Toronto",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
            description: "A key center for Orthodox Christians in Toronto.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2d/St_John_the_Baptist_Toronto.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 48. Russian Orthodox Church of St. George – Australia, Sydney
        Place(
            name: "Russian Orthodox Church of St. George",
            country: "Australia",
            city: "Sydney",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            description: "A vibrant Orthodox parish in the heart of Sydney.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/6b/St_George_Sydney.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 49. Orthodox Church of the Holy Trinity – France, Paris
        Place(
            name: "Orthodox Church of the Holy Trinity",
            country: "France",
            city: "Paris",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            description: "A center for Orthodox worship in Paris with historical significance.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/Paris_Orthodox_Church.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 50. Russian Orthodox Church of St. Mary – Germany, Berlin
        Place(
            name: "Russian Orthodox Church of St. Mary",
            country: "Germany",
            city: "Berlin",
            category: .churches,
            subcategory: .holyRelics,
            coordinate: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
            description: "An important Orthodox church in Berlin, serving the local community.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/45/Berlin_Orthodox_Church.jpg")!,
            sourceURL: URL(string: "https://azbyka.ru/palomnik/")!
        ),
        // 1. Heiligenkreuz Abbey – Austria (Cross Particles)
        Place(
            name: "Heiligenkreuz Abbey",
            country: "Austria",
            city: "Heiligenkreuz",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 48.0552, longitude: 16.1256),
            description: "A Cistercian monastery in the Vienna Woods, housing a True Cross relic donated in the 12th century.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/65/Stift_Heiligenkreuz_Kreuzgang.jpg")!,
            sourceURL: URL(string: "https://www.stift-heiligenkreuz.at/")!
        ),
        // 2. Mother See of Holy Etchmiadzin – Armenia
        Place(
            name: "Mother See of Holy Etchmiadzin",
            country: "Armenia",
            city: "Vagharshapat (Ejmiatsin)",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 40.1633, longitude: 44.2934),
            description: "Spiritual center of the Armenian Apostolic Church, housing a True Cross fragment.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/85/Ejmiatsin_Cathedral.jpg")!,
            sourceURL: URL(string: "https://www.armenianchurch.org/")!
        ),
        // 3. Church of Our Lady (Onthaalkerk) – Belgium
        Place(
            name: "Church of Our Lady (Onthaalkerk)",
            country: "Belgium",
            city: "Bruges",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 51.2043, longitude: 3.2247),
            description: "Medieval church with a True Cross relic and Michelangelo’s *Madonna and Child*.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2d/Brugge_Church_of_Our_Lady_R01.jpg")!,
            sourceURL: URL(string: "https://www.brugge.be/")!
        ),
        // 4. St. Cecilia Church – Germany
        Place(
            name: "St. Cecilia Church",
            country: "Germany",
            city: "Düsseldorf",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 51.2199, longitude: 6.7866),
            description: "Historic church in Düsseldorf, traditionally linked to a True Cross relic.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/66/Duesseldorf.jpg")!,
            sourceURL: URL(string: "https://www.duesseldorf.de/")!
        ),
        // 5. Iviron Monastery (Mount Athos) – Greece (Cross Particles version)
        Place(
            name: "Iviron Monastery",
            country: "Greece",
            city: "Mount Athos",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 40.2646, longitude: 24.2771),
            description: "Georgian-founded monastery on Mount Athos, preserving a True Cross relic.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/39/Iviron_Monastery.jpg")!,
            sourceURL: URL(string: "https://www.athos.ru/")!
        ),
        // 6. Svetitskhoveli Cathedral – Georgia (Cross Particles version)
        Place(
            name: "Svetitskhoveli Cathedral",
            country: "Georgia",
            city: "Mtskheta",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 41.8407, longitude: 44.7188),
            description: "UNESCO-listed cathedral, said to hold Christ’s robe and a True Cross fragment.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e7/Svetitskhoveli_Cathedral.jpg")!,
            sourceURL: URL(string: "https://whc.unesco.org/en/list/708/")!
        ),
        // 7. Church of the Holy Sepulchre – Israel
        Place(
            name: "Church of the Holy Sepulchre",
            country: "Israel",
            city: "Jerusalem",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 31.7784, longitude: 35.2296),
            description: "Contains the largest True Cross fragment in the Chapel of the Cross.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Church_of_the_Holy_Sepulchre.jpg")!,
            sourceURL: URL(string: "https://www.custodia.org/")!
        ),
        // 8. Monasterio de Santo Toribio de Liébana – Spain
        Place(
            name: "Monasterio de Santo Toribio de Liébana",
            country: "Spain",
            city: "Camaleño (Cantabria)",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 43.1465, longitude: -4.6142),
            description: "Holds the *Lignum Crucis*, a major True Cross relic.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Monasterio_de_Santo_Toribio_de_Li%C3%A9bana.jpg")!,
            sourceURL: URL(string: "https://www.turismodecantabria.com/")!
        ),
        // 9. Basilica di Santa Croce in Gerusalemme – Italy
        Place(
            name: "Basilica di Santa Croce in Gerusalemme",
            country: "Italy",
            city: "Rome",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 41.8862, longitude: 12.5122),
            description: "Built by St. Helena, houses earth from Golgotha and True Cross fragments.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Basilica_di_Santa_Croce_in_Gerusalemme_Roma.jpg")!,
            sourceURL: URL(string: "https://www.rome.net/")!
        ),
        // 10. Stavrovouni Monastery – Cyprus
        Place(
            name: "Stavrovouni Monastery",
            country: "Cyprus",
            city: "Larnaca District",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 34.8740, longitude: 33.4333),
            description: "Founded by St. Helena, with a True Cross fragment in a silver cross.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/57/Stavrovouni_monastery%2C_Larnaca_-_panoramio_%2812%29.jpg")!,
            sourceURL: URL(string: "https://www.visitcyprus.com/")!
        ),
        // 11. Old Believers' Grebenshchikov Cathedral – Latvia
        Place(
            name: "Old Believers' Grebenshchikov Cathedral",
            country: "Latvia",
            city: "Riga",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 56.9438, longitude: 24.1240),
            description: "Old Believers’ cathedral safeguarding a True Cross fragment.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/20/Grebenshchikov_church.jpg")!,
            sourceURL: URL(string: "https://www.riga.lv/")!
        ),
        // 12. Alexander-Svirsky Monastery – Russia
        Place(
            name: "Alexander-Svirsky Monastery",
            country: "Russia",
            city: "Staraya Sloboda (Leningrad Oblast)",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 60.9968, longitude: 35.0565),
            description: "15th-century monastery with a True Cross relic.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/6b/Alexander-Svirsky_Monastery.jpg")!,
            sourceURL: URL(string: "https://www.russianmonasteries.org/")!
        ),
        // 13. Krestovozdvizhenska Church – Ukraine
        Place(
            name: "Krestovozdvizhenska Church",
            country: "Ukraine",
            city: "Vinnytsia",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 49.2322, longitude: 28.4682),
            description: "19th-century church housing a True Cross fragment.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/98/Vinnytsia_Orthodox_Church.jpg")!,
            sourceURL: URL(string: "https://visit.vinnytsia.ua/")!
        ),
        // 14. Notre-Dame de Paris – France
        Place(
            name: "Notre-Dame de Paris",
            country: "France",
            city: "Paris",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 48.8530, longitude: 2.3499),
            description: "Housed a True Cross fragment before the 2019 fire; relic status unclear post-restoration.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Notre_Dame_de_Paris.jpg")!,
            sourceURL: URL(string: "https://www.notredamedeparis.fr/")!
        ),
        // 15. Cetinje Monastery – Montenegro
        Place(
            name: "Cetinje Monastery",
            country: "Montenegro",
            city: "Cetinje",
            category: .churches,
            subcategory: .crossParticles,
            coordinate: CLLocationCoordinate2D(latitude: 42.3905, longitude: 18.9154),
            description: "Holds a True Cross relic once owned by the Russian Imperial family.",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/d0/Cetinjski_manastir.JPG")!,
            sourceURL: URL(string: "https://www.montenegro.travel/")!
        )
    ]
    // ✅ Improved function: Filter by both category and subcategory
        func filterPlaces(category: HolyPlaceCategory?, subcategory: ChurchSubcategory?) -> [Place] {
            return places.filter { place in
                let matchesCategory = category == nil || place.category == category
                let matchesSubcategory = subcategory == nil || place.subcategory == subcategory
                return matchesCategory && matchesSubcategory
            }
        }

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
