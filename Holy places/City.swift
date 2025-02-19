import Foundation

struct City: Identifiable, Codable {
    let id = UUID()
    let name: String
}

class CityService {
    static let shared = CityService()
    
    // ✅ Fetch cities for a given country (Online Query)
    func fetchCities(for countryCode: String, completion: @escaping ([City]) -> Void) {
        let urlString = "https://overpass-api.de/api/interpreter?data=[out:json];area[\"ISO3166-1\"=\"\(countryCode)\"]->.searchArea;(node[\"place\"=\"city\"](area.searchArea););out;"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("❌ No Data Received")
                completion([])
                return
            }
            
            do {
                let result = try JSONDecoder().decode(OverpassResponse.self, from: data)
                let cities = result.elements.compactMap { City(name: $0.tags?.name ?? "Unknown City") }
                DispatchQueue.main.async {
                    completion(cities)
                }
            } catch {
                print("❌ Decoding Error: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}

// 🔹 Structs for Overpass API Response
struct OverpassResponse: Codable {
    let elements: [OverpassElement]
}

struct OverpassElement: Codable {
    let tags: OverpassTags?
}

struct OverpassTags: Codable {
    let name: String?
}
