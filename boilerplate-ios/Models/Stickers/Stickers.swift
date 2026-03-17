//
//  Stickers.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import Foundation
import CoreLocation

struct Sticker: Identifiable, Equatable {
    let  id: String
    let  coordinate: CLLocationCoordinate2D
    let  asset: StickerAsset
    let  tier: StickerTier
    let  unlockRule: StickerUnlockRule
    let  detail: StickerDetail
    var  hasHiddenDepth: Bool
    // Whether this sticker hints at deeper content below it
    static func == (lhs: Sticker, rhs: Sticker) -> Bool {
        lhs.id == rhs.id
    }
    // this func makes xcode stop crying about the struct not conforimign to protocol equatable

}
