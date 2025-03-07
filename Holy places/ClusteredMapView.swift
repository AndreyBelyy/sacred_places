import SwiftUI
import MapKit

struct ClusteredMapView: UIViewRepresentable {
    @Binding var selectedPlace: Place?
    var places: [Place]
    @Binding var mapRegion: MKCoordinateRegion?

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: ClusteredMapView

        init(parent: ClusteredMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let placeAnnotation = annotation as? PlaceAnnotation {
                DispatchQueue.main.async {
                    self.parent.selectedPlace = placeAnnotation.place
                }
            }
        }

        // ✅ Show Place Names Under Pins & Handle Callouts
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil // Keep user's blue dot
            }

            let identifier = "marker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.markerTintColor = .red // ✅ Red Pin
                annotationView?.canShowCallout = true  // ✅ Enables name display
                annotationView?.titleVisibility = .visible  // ✅ Always show the title

                // ✅ Add a detail button inside the callout
                let detailButton = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = detailButton
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }

        // ✅ Handle Callout Accessory Tap (Opens Place Details)
        func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let placeAnnotation = annotationView.annotation as? PlaceAnnotation {
                DispatchQueue.main.async {
                    self.parent.selectedPlace = placeAnnotation.place
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")

        updateAnnotations(for: mapView)

        if let region = mapRegion {
            mapView.setRegion(region, animated: true)
        }

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(for: mapView)

        if let region = mapRegion {
            mapView.setRegion(region, animated: true)
        }
    }

    private func updateAnnotations(for mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = places.map { PlaceAnnotation(place: $0) }
        mapView.addAnnotations(annotations)
    }
}
