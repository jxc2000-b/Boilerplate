//
//  AccessibleAppShellView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/10/26.
//

import SwiftUI

struct AccessibleAppShellView: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.rootTabs) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder
    private func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            AccessibleTabPlaceholderView(tab: tab, subtitle: "Replace with HomeView.swift")
        case .profile:
            AccessibleTabPlaceholderView(tab: tab, subtitle: "Replace with ProfileView.swift")
        case .search:
            AccessibleTabPlaceholderView(tab: tab, subtitle: "Replace with SearchView.swift")
        case .maps:
            AccessibleTabPlaceholderView(tab: tab, subtitle: "Replace with MapsView.swift")
        case .chat:
            AccessibleTabPlaceholderView(tab: tab, subtitle: "Replace with ChatView.swift")
        case .binoculars, .navigation, .play, .tray, .backarrow, .friends, .notifications, .feed:
            EmptyView()
        }
    }
}

private struct AccessibleTabPlaceholderView: View {
    let tab: AppTab
    let subtitle: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: tab.icon)
                    .font(.system(size: 42, weight: .semibold))
                Text(tab.title)
                    .font(.title.bold())
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle(tab.title)
        }
    }
}
