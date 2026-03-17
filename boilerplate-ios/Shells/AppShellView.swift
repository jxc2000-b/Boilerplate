//
//  AppShellView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/10/26.
//

import SwiftUI

struct AppShellView: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                TabView(selection: $selectedTab) {
                    ForEach(AppTab.rootTabs) { tab in
                        tabView(for: tab)
                            .tabItem {
                                Label(tab.title, systemImage: tab.icon)
                            }
                            .tag(tab)
                    }
                }

                HStack {
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(8)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)

                    Spacer()

                    HStack(spacing: 6) {
                        Button {
                        } label: {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 34, height: 34)
                        }
                        .buttonStyle(.glass)

                        Button {
                        } label: {
                            Image(systemName: "tray.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 34, height: 34)
                        }
                        .buttonStyle(.glass)
                    }
                    .foregroundStyle(.primary)
                    .padding(4)
                    .glassEffect( in: Capsule())
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, proxy.safeAreaInsets.bottom + 58)
            }
        }
    }

    @ViewBuilder
    private func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            TabPlaceholderView(tab: tab, subtitle: "Replace with HomeView.swift")
        case .profile:
            TabPlaceholderView(tab: tab, subtitle: "Replace with ProfileView.swift")
        case .search:
            TabPlaceholderView(tab: tab, subtitle: "Replace with SearchView.swift")
        case .maps:
            TabPlaceholderView(tab: tab, subtitle: "Replace with MapsView.swift")
        case .chat:
            TabPlaceholderView(tab: tab, subtitle: "Replace with ChatView.swift")
        case .binoculars, .navigation, .play, .tray, .backarrow, .friends, .notifications, .feed:
            EmptyView()
        }
    }
}

private struct TabPlaceholderView: View {
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

#Preview {
    AppShellView(selectedTab: .constant(.home))
}
