//
//  ZoomLevel.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/13/26.
//

import MapKit

struct ZoomLevel {

    static func tier(for latitudeDelta: Double) -> StickerTier? {
        if latitudeDelta < StickerTier.street.latitudeDeltaThreshold {
            return .street
        } else if latitudeDelta < StickerTier.neighbourhood.latitudeDeltaThreshold {
            return .neighbourhood
        } else if latitudeDelta < StickerTier.city.latitudeDeltaThreshold {
            return .city
        } else if latitudeDelta < StickerTier.province.latitudeDeltaThreshold {
            return .province
        } else if latitudeDelta < StickerTier.region.latitudeDeltaThreshold {
            return .region
        }
        return nil
    }

    static func isZoomedIn(forTier tier: StickerTier, latitudeDelta: Double) -> Bool {
        latitudeDelta < tier.latitudeDeltaThreshold
    }
}
