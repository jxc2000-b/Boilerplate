import SwiftUI
import MapKit
import Combine

class MapViewModel: ObservableObject {

    // MARK: - Region
    var _mkCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.7490, longitude: -84.3880),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )

    @Published var trigger = false

    // Reference to coordinator so we can flag programmatic updates
    weak var mapCoordinator: AppMapView.Coordinator?

    func setRegion(_ region: MKCoordinateRegion) {
        _mkCoordinateRegion = region
        mapCoordinator?.isProgrammaticUpdate = true  // 👈 flag it as our change
        trigger.toggle()
    }

    // MARK: - Zoom / Unlock State
    @Published var currentLatitudeDelta: Double = 0.5
    @Published var manuallyUnlockedIds: Set<String> = []

    var unlockContext: UnlockContext {
        UnlockContext(
            currentLatitudeDelta: currentLatitudeDelta,
            userLocation: nil,
            stickerLocation: nil,
            manuallyUnlockedIds: manuallyUnlockedIds
        )
    }

    // MARK: - Visible Stickers
    @Published var visibleStickers: [Sticker] = []

    func updateVisibleStickers() {
        visibleStickers = StickerStore.shared.visibleStickers(context: unlockContext)
    }

    // MARK: - Visible Map Feature Overlays
    @Published var visibleMapFeatures: [MapFeatureOverlay] = []

    func updateVisibleMapFeatures() {
        visibleMapFeatures = MapFeatureOverlayStore.shared.visibleFeatures(
            currentLatitudeDelta: currentLatitudeDelta
        )
    }

    // MARK: - Selected Sticker
    @Published var selectedSticker: Sticker?

    func selectSticker(_ sticker: Sticker) {
        selectedSticker = sticker
    }

    func clearSelection() {
        selectedSticker = nil
    }

    // MARK: - Hint System
    @Published var hintStickers: [Sticker] = []

    func updateHintStickers() {
        let all = StickerStore.shared.allStickers
        hintStickers = all.filter { sticker in
            !visibleStickers.contains(sticker) &&
            sticker.tier.latitudeDeltaThreshold * 2 > currentLatitudeDelta &&
            sticker.hasHiddenDepth
        }
    }
}
