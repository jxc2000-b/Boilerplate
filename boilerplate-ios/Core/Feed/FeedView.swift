//
//  FeedView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var store = FeedStore()
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero

    private var visibleRows: [FeedRowModel] {
        guard currentIndex < store.rows.count else { return [] }
        return Array(store.rows.dropFirst(currentIndex).prefix(3))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if visibleRows.isEmpty {
                    ContentUnavailableView(
                        "You're all caught up",
                        systemImage: "checkmark.heart.fill",
                        description: Text("Come back later for more local profiles.")
                    )
                } else {
                    VStack(spacing: 20) {
                        ZStack {
                            ForEach(Array(visibleRows.enumerated()), id: \.element.id) { index, row in
                                cardView(for: row, index: index)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 520)

                        HStack(spacing: 30) {
                            feedActionButton(symbol: "xmark", color: .secondary, size: 56) {
                                swipeToNext()
                            }

                            feedActionButton(
                                symbol: currentRow?.isBookmarked == true ? "bookmark.fill" : "bookmark",
                                color: .accentColor,
                                size: 52
                            ) {
                                if let id = currentRow?.id {
                                    store.toggleBookmarked(for: id)
                                }
                            }

                            feedActionButton(symbol: "heart.fill", color: .pink, size: 64) {
                                if let id = currentRow?.id {
                                    store.toggleLiked(for: id)
                                }
                                swipeToNext()
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Feed")
            .onAppear {
                markCurrentRead()
            }
        }
    }

    private var currentRow: FeedRowModel? {
        guard currentIndex < store.rows.count else { return nil }
        return store.rows[currentIndex]
    }

    private func markCurrentRead() {
        if let id = currentRow?.id {
            store.markRead(id)
        }
    }

    private func swipeToNext() {
        guard let currentID = currentRow?.id else { return }
        store.markRead(currentID)
        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            currentIndex += 1
            dragOffset = .zero
        }
        markCurrentRead()
    }

    private func swipeGesture(for row: FeedRowModel) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard currentRow?.id == row.id else { return }
                dragOffset = value.translation
            }
            .onEnded { value in
                guard currentRow?.id == row.id else { return }
                let threshold: CGFloat = 110
                if value.translation.width > threshold {
                    store.toggleLiked(for: row.id)
                    swipeToNext()
                } else if value.translation.width < -threshold {
                    swipeToNext()
                } else {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    @ViewBuilder
    private func cardView(for row: FeedRowModel, index: Int) -> some View {
        let base = FeedCardView(row: row)
            .offset(y: CGFloat(index) * 12)
            .scaleEffect(1 - CGFloat(index) * 0.04)
            .opacity(index == 2 ? 0.65 : 1)
            .offset(x: index == 0 ? dragOffset.width : 0)
            .rotationEffect(.degrees(index == 0 ? Double(dragOffset.width / 18) : 0))
            .animation(.spring(response: 0.28, dampingFraction: 0.86), value: currentIndex)

        if index == 0 {
            base.gesture(swipeGesture(for: row))
        } else {
            base
        }
    }

    @ViewBuilder
    private func feedActionButton(symbol: String, color: Color, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: size, height: size)
                .background(.thinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Card view

private struct FeedCardView: View {
    let row: FeedRowModel

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color.accentColor.opacity(0.55),
                    Color.purple.opacity(0.45),
                    Color.black.opacity(0.85)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(Self.dateFormatter.string(from: row.createdAt))
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())

                    Spacer()

                    if row.isBookmarked {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.yellow)
                    }
                    if row.isLiked {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.pink)
                    }
                }

                Spacer()

                Text(row.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(row.body)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(5)

                if !row.isRead {
                    Label("New", systemImage: "sparkles")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .accessibilityLabel("Unread profile")
                }
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 16, y: 8)
        .padding(.horizontal, 20)
    }
}

#Preview {
    FeedView()
}
