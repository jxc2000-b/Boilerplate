//
//  MapView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import SwiftUI


struct MapView: View {
    @StateObject var mapViewModel = MapViewModel()
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            AppMapView(
                mapViewModel: mapViewModel,
                tappedSticker: { sticker in
                    if let sticker = sticker {
                        mapViewModel.selectSticker(sticker)
                        showDetail = true
                    }
                }
            )
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    CurrentLocationButton(setRegion: mapViewModel.setRegion).padding()
                }
            }
            
            if !mapViewModel.hintStickers.isEmpty {
                VStack{
                    Spacer()
                    ZoomHintView().padding(.bottom, 100)
                }
            }
        }
        
        .sheet(isPresented: $showDetail){
            if let sticker = mapViewModel.selectedSticker {
                StickerDetailSheet(sticker: sticker)
            }
        }
        
        .onAppear {
            mapViewModel.updateVisibleStickers()
        }
    }
}
