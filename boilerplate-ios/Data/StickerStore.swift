//
//  StickerStore.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/12/26.
//

import Foundation
import CoreLocation

class StickerStore {
    static let shared = StickerStore()

    let allStickers: [Sticker] = [

        // Bank of America Plaza — City tier
        Sticker(
            id: "bank-of-america-plaza",
            coordinate: CLLocationCoordinate2D(
                latitude: 33.77104294356303,
                longitude: -84.3861163676881
            ),
            asset: StickerAsset(
                imageName: "sticker_bofa_plaza",
                size: CGSize(width: 32, height: 32),
                animationType: .none,
                isPixelArt: true
            ),
            tier: .city,
            unlockRule: StickerUnlockRule(
                // Visible at city zoom and stays visible all the way into street — no minDelta floor
                conditions: [.zoomRange(maxLatitudeDelta: 1.0, minLatitudeDelta: nil)],
                requirement: .any
            ),
            detail: StickerDetail(
                title: "Bank of America Plaza",
                description: "The tallest building in Atlanta, standing at 1,023 feet.",
                category: .landmark,
                actionLabel: "Get Directions",
                actionURL: URL(string: "maps://?address=600+Peachtree+St+NE,+Atlanta,+GA"),
                address: "600 Peachtree St NE, Atlanta, GA",
                dateRange: nil
            ),
            hasHiddenDepth: true
        ),

        // Mercedes-Benz Stadium — City tier
        Sticker(
            id: "mercedes-benz-stadium",
            coordinate: CLLocationCoordinate2D(
                latitude: 33.75571565884708,
                longitude: -84.40054758791024
            ),
            asset: StickerAsset(
                imageName: "sticker_mercedes_benz_stadium",
                size: CGSize(width: 32, height: 32),
                animationType: .none,
                isPixelArt: true
            ),
            tier: .city,
            unlockRule: StickerUnlockRule(
                conditions: [.zoom(belowLatitudeDelta: 1.0)],
                requirement: .any
            ),
            detail: StickerDetail(
                title: "Mercedes-Benz Stadium",
                description: "Home of the Atlanta Falcons and Atlanta United FC.",
                category: .venue,
                actionLabel: "Get Directions",
                actionURL: URL(string: "maps://?address=1+AMB+Dr+NW,+Atlanta,+GA"),
                address: "1 AMB Dr NW, Atlanta, GA",
                dateRange: nil
            ),
            hasHiddenDepth: false
        )
    ]

    func visibleStickers(context: UnlockContext) -> [Sticker] {
        allStickers.filter { $0.unlockRule.isUnlocked(isUnlockedContext: context) }
    }

    func stickers(for tier: StickerTier) -> [Sticker] {
        allStickers.filter { $0.tier == tier }
    }
}
