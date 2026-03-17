//
//  StickerTier.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import Foundation

enum StickerTier: Int, Comparable {
    case city = 1  // zoomed out — landmark stickers
    case neighbourhood = 2  // mid zoom — venue stickers
    case street = 3  // zoomed in — hyper local stickers
    
    
    // The latitudeDelta threshold at which this tier becomes active
   // Smaller delta = more zoomed in
    
    var latitudeDeltaThreshold: Double {
        switch self {
        case .city : return 0.5 // visible when delta < 0.5
        case .neighbourhood: return 0.05 // visible when delta < 0.05
        case .street: return 0.01 // visible when delta < 0.01
        }
    }
    // various deltas (i guess zoom levels) for each tier of sticker
        
    var displayName: String {
        switch self {
        case .city: return "City"
        case .neighbourhood: return "Neighbourhood"
        case .street: return "Street"
        }
    }
    // ??
    
    static func < (lhs: StickerTier, rhs: StickerTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    //stops xcode from cryign about not conforming to comparable
    
    var nextTier: StickerTier? {
        switch self {
        case .city: return .neighbourhood
        case .neighbourhood: return .street
        case .street: return nil
        }
    }
    // The tier that replaces this one when zooming in
}
