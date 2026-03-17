//
//  FeedLocalStateStore.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//

import Foundation

final class FeedLocalStateStore {

    static let shared = FeedLocalStateStore()

    private let fileName = "feed_local_state.json"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // In-memory map keyed by feed item id.
    private(set) var states: [String: FeedItemLocalState] = [:]

    private init() {
        states = load()
    }

    // MARK: - File URL

    private var fileURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory,
                                                   in: .userDomainMask)[0]
        // Create the directory if it doesn't exist yet.
        try? FileManager.default.createDirectory(at: appSupport,
                                                  withIntermediateDirectories: true)
        return appSupport.appendingPathComponent(fileName)
    }

    // MARK: - Persistence

    private func load() -> [String: FeedItemLocalState] {
        guard let data = try? Data(contentsOf: fileURL) else { return [:] }
        return (try? decoder.decode([String: FeedItemLocalState].self, from: data)) ?? [:]
    }

    private func save() {
        guard let data = try? encoder.encode(states) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    // MARK: - Helpers

    func state(for id: String) -> FeedItemLocalState {
        states[id] ?? FeedItemLocalState(id: id, isLiked: false, isBookmarked: false, isRead: false)
    }

    func setState(_ state: FeedItemLocalState) {
        states[state.id] = state
        save()
    }

    func toggleLiked(for id: String) {
        var s = state(for: id)
        s = FeedItemLocalState(id: s.id, isLiked: !s.isLiked,
                               isBookmarked: s.isBookmarked, isRead: s.isRead)
        setState(s)
    }

    func toggleBookmarked(for id: String) {
        var s = state(for: id)
        s = FeedItemLocalState(id: s.id, isLiked: s.isLiked,
                               isBookmarked: !s.isBookmarked, isRead: s.isRead)
        setState(s)
    }

    func markRead(_ id: String) {
        var s = state(for: id)
        guard !s.isRead else { return }
        s = FeedItemLocalState(id: s.id, isLiked: s.isLiked,
                               isBookmarked: s.isBookmarked, isRead: true)
        setState(s)
    }
}
