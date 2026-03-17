//
//  MapFeatureOverlay.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation
import CoreLocation
import MapKit

/// A renderable map overlay feature (e.g. a loop/polyline around a city area).
/// Parallel concept to Sticker, but for MKOverlay-based content.
struct MapFeatureOverlay: Identifiable, Equatable {
    let id: String
    let coordinates: [CLLocationCoordinate2D]
    let tier: MapFeatureTier
    let unlockRule: MapFeatureUnlockRule

    static func == (lhs: MapFeatureOverlay, rhs: MapFeatureOverlay) -> Bool {
        lhs.id == rhs.id
    }

    /// Build an MKPolyline from this feature's coordinates.
    func makePolyline() -> MKPolyline {
        MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}
