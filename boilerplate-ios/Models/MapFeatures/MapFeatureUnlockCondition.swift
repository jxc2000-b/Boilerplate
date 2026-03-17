//
//  MapFeatureUnlockCondition.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation

/// Unlock conditions for MapFeatureOverlay — mirrors the sticker unlock system
/// but is kept separate so overlay rules can diverge from sticker rules over time.
enum MapFeatureUnlockCondition: Equatable {
    /// Visible whenever latitudeDelta is below the threshold (zoomed in enough).
    case zoom(belowLatitudeDelta: Double)
    /// Visible within a zoom range: delta < maxLatitudeDelta and, if minLatitudeDelta
    /// is given, delta >= minLatitudeDelta.
    case zoomRange(maxLatitudeDelta: Double, minLatitudeDelta: Double?)

    static func == (lhs: MapFeatureUnlockCondition, rhs: MapFeatureUnlockCondition) -> Bool {
        switch (lhs, rhs) {
        case (.zoom(let a), .zoom(let b)):
            return a == b
        case (.zoomRange(let aMax, let aMin), .zoomRange(let bMax, let bMin)):
            return aMax == bMax && aMin == bMin
        default:
            return false
        }
    }

    func isMet(currentLatitudeDelta: Double) -> Bool {
        switch self {
        case .zoom(let threshold):
            return currentLatitudeDelta < threshold
        case .zoomRange(let maxDelta, let minDelta):
            let delta = currentLatitudeDelta
            return delta < maxDelta && minDelta.map { delta >= $0 } ?? true
        }
    }
}

enum MapFeatureUnlockRequirement: Equatable {
    case all
    case any
}

struct MapFeatureUnlockRule: Equatable {
    var conditions: [MapFeatureUnlockCondition]
    var requirement: MapFeatureUnlockRequirement

    static func == (lhs: MapFeatureUnlockRule, rhs: MapFeatureUnlockRule) -> Bool {
        lhs.conditions == rhs.conditions && lhs.requirement == rhs.requirement
    }

    func isUnlocked(currentLatitudeDelta: Double) -> Bool {
        switch requirement {
        case .all:
            return conditions.allSatisfy { $0.isMet(currentLatitudeDelta: currentLatitudeDelta) }
        case .any:
            return conditions.contains { $0.isMet(currentLatitudeDelta: currentLatitudeDelta) }
        }
    }
}
