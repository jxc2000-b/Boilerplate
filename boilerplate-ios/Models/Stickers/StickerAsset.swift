//
//  StickerAsset.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/12/26.
//

import UIKit

enum StickerAnimationType{
    case none
    case spriteSheet(frameCount: Int, fps: Double)
    case lottie(filename: String)
    case gif(filename: String)
}

struct StickerAsset {
    var imageName: String
    var size: CGSize
    var animationType: StickerAnimationType
    var isPixelArt: Bool 
}
