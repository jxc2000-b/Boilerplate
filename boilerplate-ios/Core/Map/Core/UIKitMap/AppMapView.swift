import SwiftUI
import MapKit

struct AppMapView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var mapViewModel: MapViewModel

    var tappedSticker: (Sticker?) -> Void

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.mapType = .satellite
        
        let config = MKStandardMapConfiguration()
        config.pointOfInterestFilter = .excludingAll
        config.showsTraffic = false
        mapView.preferredConfiguration = config

        // Hide the built-in Apple map entirely — CartoDB replaces it
        mapView.mapType = .mutedStandard
        mapView.register(
            StickerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(StickerAnnotationView.self)
        )

        // Add CartoDB Positron tiles as the base layer
        let tileOverlay = MapTileOverlay()
        mapView.addOverlay(tileOverlay, level: .aboveLabels)

        // Set initial region
        mapView.setRegion(mapViewModel._mkCoordinateRegion, animated: false)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Only sync region if triggered programmatically
        if context.coordinator.isProgrammaticUpdate && !context.coordinator.isRegionChanging {
            mapView.setRegion(mapViewModel._mkCoordinateRegion, animated: true)
            context.coordinator.isProgrammaticUpdate = false
        }

        // Sync sticker annotations
        let current = Set(mapViewModel.visibleStickers.map { StickerAnnotation(sticker: $0) })
        let existing = Set(mapView.annotations.compactMap { $0 as? StickerAnnotation })

        let toAdd = current.subtracting(existing)
        let toRemove = existing.subtracting(current)

        if !toAdd.isEmpty { mapView.addAnnotations(Array(toAdd)) }
        if !toRemove.isEmpty { mapView.removeAnnotations(Array(toRemove)) }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AppMapView
        private(set) var isRegionChanging = false
        var isProgrammaticUpdate = false

        init(_ parent: AppMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            isRegionChanging = true
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            isRegionChanging = false
            let newDelta = mapView.region.span.latitudeDelta

            DispatchQueue.main.async {
                self.parent.mapViewModel.currentLatitudeDelta = newDelta
                self.parent.mapViewModel.updateVisibleStickers()
                self.parent.mapViewModel.updateHintStickers()
            }
        }

        // MARK: Overlay renderer — handles both tile layer and future sticker overlays
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                // 👈 serve the CartoDB tile renderer
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        // Provide the custom annotation view for each sticker
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let stickerAnnotation = annotation as? StickerAnnotation else { return nil }

            let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: NSStringFromClass(StickerAnnotationView.self),
                for: stickerAnnotation
            ) as? StickerAnnotationView

            view?.configure(with: stickerAnnotation.sticker)
            return view
        }

        // Sticker tapped
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let stickerView = view as? StickerAnnotationView,
                  let sticker = stickerView.sticker else { return }
            mapView.deselectAnnotation(view.annotation, animated: false)
            parent.tappedSticker(sticker)
        }
    }
}
