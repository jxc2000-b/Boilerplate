//
//  StickerDetailSheet.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/13/26.
//

import SwiftUI

struct StickerDetailSheet: View {
    let sticker: Sticker
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Header
            HStack {
                Image(sticker.asset.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(sticker.detail.title)
                        .font(.headline)
                    Text(sticker.detail.category.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            // Description
            Text(sticker.detail.description)
                .font(.body)
                .foregroundColor(.primary)
            
            // Address
            if let address = sticker.detail.address {
                Label(address, systemImage: "mappin.circle")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Date range (for events)
            if let dateRange = sticker.detail.dateRange {
                Label(
                    "\(dateRange.start.formatted(date: .abbreviated, time: .omitted)) – \(dateRange.end.formatted(date: .abbreviated, time: .omitted))",
                    systemImage: "calendar"
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            // Action button
            if let label = sticker.detail.actionLabel,
               let url = sticker.detail.actionURL {
                Link(destination: url) {
                    Text(label)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
