//
//  ContentView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/9/26.
//

import SwiftUI

struct AppRootView: View {
    var body: some View {
        MapView()
    }
}

#Preview {
    AppRootView()
}



//import SwiftUI
//
//struct AppRootView: View {
//    @Environment(AppPreferences.self) private var appPreferences
//    @State private var selectedTab: AppTab = .home
//    
//    var body: some View {
//        Group {
//            switch appPreferences.shellMode {
//            case .standard:
//                AppShellView(selectedTab: $selectedTab)
//            case .accessible:
//                AccessibleAppShellView(selectedTab: $selectedTab)
//            }
//        }
//    }
//}
//
//
//#Preview {
//    AppRootView()
//        .environment(AppPreferences())
//}
