import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let place: Place
    var coordinate: CLLocationCoordinate2D { place.coordinate }
    var title: String? { place.name }
    
    init(place: Place) {
        self.place = place
    }
}