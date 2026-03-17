//
//  AppPreferences.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/10/26.
//

import SwiftUI
import Observation

enum ShellMode: String, CaseIterable {
    case standard
    case accessible
}

@Observable
final class AppPreferences {
    var shellMode: ShellMode = .standard
}
