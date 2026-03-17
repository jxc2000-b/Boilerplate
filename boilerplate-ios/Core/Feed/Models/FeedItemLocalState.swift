//
//  FeedItemLocalState.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation

struct FeedItemLocalState: Codable, Equatable {
    let id: String
    var isLiked: Bool
    var isBookmarked: Bool
    var isRead: Bool
}
