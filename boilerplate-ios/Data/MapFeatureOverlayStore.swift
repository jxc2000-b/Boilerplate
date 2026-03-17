//
//  MapFeatureOverlayStore.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation
import CoreLocation

class MapFeatureOverlayStore {
    static let shared = MapFeatureOverlayStore()

    let allFeatures: [MapFeatureOverlay] = [

        // Rough approximation of the Atlanta BeltLine loop.
        // Coordinates trace the ~22-mile loop from NE → NW → SW → SE and back.
        // These are approximate waypoints — not surveyed geometry.
        MapFeatureOverlay(
            id: "atlanta-beltline",
            coordinates: [
                // NE quadrant
                CLLocationCoordinate2D(latitude: 33.7703, longitude: -84.3548),
                CLLocationCoordinate2D(latitude: 33.7781, longitude: -84.3612),
                CLLocationCoordinate2D(latitude: 33.7838, longitude: -84.3710),
                CLLocationCoordinate2D(latitude: 33.7855, longitude: -84.3832),
                // N / NW
                CLLocationCoordinate2D(latitude: 33.7840, longitude: -84.3940),
                CLLocationCoordinate2D(latitude: 33.7800, longitude: -84.4055),
                CLLocationCoordinate2D(latitude: 33.7730, longitude: -84.4150),
                // W quadrant
                CLLocationCoordinate2D(latitude: 33.7640, longitude: -84.4205),
                CLLocationCoordinate2D(latitude: 33.7530, longitude: -84.4210),
                CLLocationCoordinate2D(latitude: 33.7430, longitude: -84.4165),
                // SW
                CLLocationCoordinate2D(latitude: 33.7355, longitude: -84.4065),
                CLLocationCoordinate2D(latitude: 33.7308, longitude: -84.3940),
                // S / SE
                CLLocationCoordinate2D(latitude: 33.7305, longitude: -84.3800),
                CLLocationCoordinate2D(latitude: 33.7330, longitude: -84.3670),
                CLLocationCoordinate2D(latitude: 33.7395, longitude: -84.3570),
                CLLocationCoordinate2D(latitude: 33.7488, longitude: -84.3500),
                CLLocationCoordinate2D(latitude: 33.7590, longitude: -84.3490),
                CLLocationCoordinate2D(latitude: 33.7670, longitude: -84.3510),
                // Close the loop back to NE start
                CLLocationCoordinate2D(latitude: 33.7703, longitude: -84.3548),
            ],
            tier: .city,
            unlockRule: MapFeatureUnlockRule(
                // Visible when zoomed to city level or deeper (no minimum — stays visible all the way in)
                conditions: [.zoomRange(maxLatitudeDelta: 999, minLatitudeDelta: nil)],
                requirement: .any
            )
        )
    ]

    func visibleFeatures(currentLatitudeDelta: Double) -> [MapFeatureOverlay] {
        allFeatures.filter { $0.unlockRule.isUnlocked(currentLatitudeDelta: currentLatitudeDelta) }
    }
}
