//
//  CurrentLocationButton.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/13/26.
//

import SwiftUI
import MapKit

struct CurrentLocationButton: View {
    var setRegion: (MKCoordinateRegion) -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            // Hardcoded location for now — replace with PermissionManager later
            let hardcodedCoordinate = CLLocationCoordinate2D(
                latitude: 33.7490,
                longitude: -84.3880
            )
            setRegion(MKCoordinateRegion(
                center: hardcodedCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ))
        }) {
            ZStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
                    .frame(width: 50, height: 50)
                    .background(Color(.systemBackground))
                    .cornerRadius(25)
                    .contentShape(Circle())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(radius: 3)
    }
}
