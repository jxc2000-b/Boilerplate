//
//  StickerTier.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import Foundation
import CoreGraphics

enum StickerTier: Int, Comparable {
    case region = 1       // widest zoom — multi-state/continental scale
    case province = 2     // state/province scale
    case city = 3         // city landmark scale
    case neighbourhood = 4 // venue/local scale
    case street = 5       // hyper-local scale

    // The latitudeDelta threshold at which this tier becomes visible
    // Smaller delta = more zoomed in
    var latitudeDeltaThreshold: Double {
        switch self {
        case .region: return 15.0
        case .province: return 5.0
        case .city: return 0.5
        case .neighbourhood: return 0.05
        case .street: return 0.01
        }
    }

    var displayName: String {
        switch self {
        case .region: return "Region"
        case .province: return "Province"
        case .city: return "City"
        case .neighbourhood: return "Neighbourhood"
        case .street: return "Street"
        }
    }

    static func < (lhs: StickerTier, rhs: StickerTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    //stops xcode from cryign about not conforming to comparable

    // The next (more zoomed-in) tier
    var nextTier: StickerTier? {
        switch self {
        case .region: return .province
        case .province: return .city
        case .city: return .neighbourhood
        case .neighbourhood: return .street
        case .street: return nil
        }
    }

    // The recommended pixel-art canvas size (in points) for assets at this tier.
    // Used in DEBUG builds to warn when a StickerAsset.size doesn't match.
    var recommendedAssetSize: CGSize {
        switch self {
        case .region:       return CGSize(width: 48, height: 48)
        case .province:     return CGSize(width: 48, height: 48)
        case .city:         return CGSize(width: 32, height: 32)
        case .neighbourhood: return CGSize(width: 24, height: 24)
        case .street:       return CGSize(width: 16, height: 16)
        }
    }
}
