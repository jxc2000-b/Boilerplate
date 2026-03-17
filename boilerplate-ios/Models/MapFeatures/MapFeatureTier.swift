//
//  MapFeatureTier.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation

/// Zoom tiers for map feature overlays (polylines, polygons, etc.).
/// Parallel to StickerTier but independent so overlay visibility can be tuned separately.
enum MapFeatureTier: Int, Comparable {
    case regional     = 1   // visible at widest zoom (multi-state scale)
    case city         = 2   // visible at city scale
    case neighbourhood = 3  // visible at venue/local scale
    case street       = 4   // visible at hyper-local scale

    /// The latitudeDelta threshold below which this tier becomes visible.
    var latitudeDeltaThreshold: Double {
        switch self {
        case .regional:      return 15.0
        case .city:          return 0.5
        case .neighbourhood: return 0.05
        case .street:        return 0.01
        }
    }

    var displayName: String {
        switch self {
        case .regional:      return "Regional"
        case .city:          return "City"
        case .neighbourhood: return "Neighbourhood"
        case .street:        return "Street"
        }
    }

    static func < (lhs: MapFeatureTier, rhs: MapFeatureTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
