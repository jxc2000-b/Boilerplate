//
//  FeedStore.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation
import Combine

// Convenience model used by the UI — combines immutable content with mutable local state.
struct FeedRowModel: Identifiable {
    let item: FeedItem
    var localState: FeedItemLocalState

    var id: String { item.id }
    var title: String { item.title }
    var body: String { item.body }
    var createdAt: Date { item.createdAt }
    var isLiked: Bool { localState.isLiked }
    var isBookmarked: Bool { localState.isBookmarked }
    var isRead: Bool { localState.isRead }
}

final class FeedStore: ObservableObject {

    @Published private(set) var rows: [FeedRowModel] = []

    private let seedItems: [FeedItem]
    private let localStore: FeedLocalStateStore

    init(localStore: FeedLocalStateStore = .shared) {
        self.localStore = localStore
        self.seedItems = Self.loadSeedItems()
        refresh()
    }

    // MARK: - Public actions

    func toggleLiked(for id: String) {
        localStore.toggleLiked(for: id)
        refresh()
    }

    func toggleBookmarked(for id: String) {
        localStore.toggleBookmarked(for: id)
        refresh()
    }

    func markRead(_ id: String) {
        localStore.markRead(id)
        refresh()
    }

    // MARK: - Private helpers

    private func refresh() {
        rows = seedItems
            .sorted { $0.createdAt > $1.createdAt }
            .map { item in
                FeedRowModel(item: item, localState: localStore.state(for: item.id))
            }
    }

    private static func loadSeedItems() -> [FeedItem] {
        guard let url = Bundle.main.url(forResource: "seed_feed", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([FeedItem].self, from: data)) ?? []
    }
}
