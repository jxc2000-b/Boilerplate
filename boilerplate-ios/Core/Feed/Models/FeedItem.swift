//
//  FeedItem.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation

struct FeedItem: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let body: String
    let createdAt: Date
}
