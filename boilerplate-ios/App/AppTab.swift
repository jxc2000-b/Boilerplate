//
//  AppTab.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/10/26.
//

import Foundation
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home, profile, search, maps, chat, binoculars, navigation, play, tray, backarrow, friends, notifications
    var id: String { rawValue }

    static let rootTabs: [AppTab] = [.home, .search, .maps, .chat, .profile]
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .profile:
            return "Profile"
        case .search:
            return "Search"
        case .maps:
            return "Maps"
        case .chat:
            return "Chat"
        case .binoculars:
            return "Binoculars"
        case .navigation:
            return "Navigation"
        case .play:
            return "Play"
        case .tray:
            return "Tray"
        case .backarrow:
            return "Back"
        case .friends:
            return "Friends"
        case .notifications:
            return "Notifications"
        }
    }
    
    var icon: String { 
        switch self {
        case .home:
            return "house"
        case .profile:
            return "person.crop.circle"
        case .search:
            return "magnifyingglass"
        case .maps:
            return "map"
        case .chat:
            return "message"
        case .binoculars:
            return "binoculars"
        case .navigation:
            return "location.north"
        case .play:
            return "play"
        case .tray:
            return "tray"
        case .backarrow:
            return "chevron.left"
        case .friends:
            return "person.2"
        case .notifications:
            return "bell"
        }
    }
}
