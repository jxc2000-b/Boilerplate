//
//  ZoomHintView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/13/26.
//

import SwiftUI

struct ZoomHintView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
            Text("Zoom in to discover more")
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 4)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}
