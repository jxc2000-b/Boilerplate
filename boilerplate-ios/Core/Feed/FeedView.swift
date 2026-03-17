//
//  FeedView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var store = FeedStore()

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.rows) { row in
                    FeedRowView(row: row) {
                        store.toggleLiked(for: row.id)
                    } onBookmark: {
                        store.toggleBookmarked(for: row.id)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .onTapGesture {
                        store.markRead(row.id)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Feed")
        }
    }
}

// MARK: - Row view

private struct FeedRowView: View {
    let row: FeedRowModel
    let onLike: () -> Void
    let onBookmark: () -> Void

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(row.title)
                    .font(row.isRead ? .headline : .headline.bold())
                    .foregroundStyle(row.isRead ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !row.isRead {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 8, height: 8)
                        .padding(.top, 4)
                }
            }

            Text(row.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack {
                Text(Self.dateFormatter.string(from: row.createdAt))
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                Spacer()

                Button(action: onLike) {
                    Image(systemName: row.isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(row.isLiked ? .red : .secondary)
                }
                .buttonStyle(.plain)

                Button(action: onBookmark) {
                    Image(systemName: row.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(row.isBookmarked ? Color.accentColor : Color.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    FeedView()
}
