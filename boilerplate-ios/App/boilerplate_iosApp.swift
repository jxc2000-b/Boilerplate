//
//  boilerplate_iosApp.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/9/26.
//

import SwiftUI

@main
struct boilerplate_iosApp: App {
    // Adopts AppDelegate so UIKit lifecycle hooks (and performance monitoring) are available.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
//import SwiftUI
//
//@main
//struct boilerplate_iosApp: App {
//    @State private var appPreferences = AppPreferences()
//
//    
//    init() {
//        checkSupabaseConnection()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            AppRootView()
//                .environment(appPreferences)
//        }
//    }
//}
