//
//  AppTabContentView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/10/26.
//

import Foundation
import SwiftUI

struct AppTabContentView: View {
    let tab: AppTab

    var body: some View {
        switch tab {
//        case .home: HomeView()
//        case .search: SearchView()
//        case .maps: MapsView()
//        case .chat: ChatView()
//        case .profile: ProfileView()
        case .feed: FeedView()
        default: EmptyView()
        }
    }
}
