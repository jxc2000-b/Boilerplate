//
//  StickerAnnotationView.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/13/26.
//

import UIKit
import MapKit

class StickerAnnotationView: MKAnnotationView {
    private(set) var sticker: Sticker?
    private let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupImageView()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        backgroundColor = .clear
    }

    func configure(with sticker: Sticker) {
        self.sticker = sticker

        let size = sticker.asset.size
        frame = CGRect(origin: .zero, size: size)
        imageView.frame = bounds
        centerOffset = CGPoint(x: 0, y: -size.height / 2)

        #if DEBUG
        let recommended = sticker.tier.recommendedAssetSize
        if size != recommended {
            print(
                "[StickerAsset] ⚠️ Size mismatch for '\(sticker.id)'" +
                " (tier: \(sticker.tier.displayName))" +
                " — expected \(Int(recommended.width))×\(Int(recommended.height))" +
                ", got \(Int(size.width))×\(Int(size.height))"
            )
        }
        #endif

        if sticker.asset.isPixelArt {
            imageView.layer.magnificationFilter = .nearest
            imageView.layer.minificationFilter = .nearest
        }

        // Use real asset if it exists, otherwise fall back to a
        // coloured SF Symbol so you can see the pin on the map
        if let image = UIImage(named: sticker.asset.imageName) {
            imageView.image = image
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
            imageView.image = UIImage(
                systemName: "mappin.circle.fill",
                withConfiguration: config
            )
            imageView.tintColor = sticker.tier == .city ? .systemRed : .systemBlue
        }

        animateIn()
    }

    // MARK: - Animations

    func animateIn() {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            completion()
        }
    }
}
