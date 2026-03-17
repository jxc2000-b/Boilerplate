//
//  StickerDetail.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/12/26.
//

import Foundation

enum StickerCategory: String {
    case landmark  = "Landmark"
    case event     = "Event"
    case venue     = "Venue"
    case food      = "Food"
    case art       = "Art"
    case music     = "Music"
}

struct StickerDetail {
    var title: String
    var description: String
    var category: StickerCategory
    var actionLabel: String?
    var actionURL: URL?
    var address: String?
    var dateRange: DateInterval?
}
