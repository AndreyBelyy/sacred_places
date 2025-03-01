import SwiftUI
import MapKit

struct ClusteredMapView: UIViewRepresentable {
    @Binding var selectedPlace: Place?
    var places: [Place]

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ClusteredMapView

        init(parent: ClusteredMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let placeAnnotation = annotation as? PlaceAnnotation {
                parent.selectedPlace = placeAnnotation.place
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKMarkerAnnotationView.self))
        mapView.register(MKClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKClusterAnnotationView.self))
        updateAnnotations(for: mapView)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(for: mapView)
    }

    private func updateAnnotations(for mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)

        let annotations = places.map { PlaceAnnotation(place: $0) }
        mapView.addAnnotations(annotations)
    }
}