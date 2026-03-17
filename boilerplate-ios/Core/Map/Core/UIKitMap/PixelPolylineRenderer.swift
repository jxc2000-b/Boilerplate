//
//  PixelPolylineRenderer.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//
import MapKit
import UIKit

final class PixelPolylineRenderer: MKOverlayRenderer {
    private let polyline: MKPolyline
    private let strokeColor: UIColor
    private let pixelSizePoints: CGFloat

    init(polyline: MKPolyline, strokeColor: UIColor, pixelSizePoints: CGFloat = 4) {
        self.polyline = polyline
        self.strokeColor = strokeColor
        self.pixelSizePoints = max(1, pixelSizePoints)
        super.init(overlay: polyline)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let rect = self.rect(for: mapRect)
        guard rect.width > 1, rect.height > 1 else { return }

        // Build path in VIEW coordinates from MKMapPoints
        let points = polyline.points()
        guard polyline.pointCount >= 2 else { return }

        let path = CGMutablePath()
        path.move(to: self.point(for: points[0]))
        for i in 1..<polyline.pointCount {
            path.addLine(to: self.point(for: points[i]))
        }

        // Downsample: 1 offscreen pixel == pixelSizePoints screen points
        let offW = Int(ceil(rect.width / pixelSizePoints))
        let offH = Int(ceil(rect.height / pixelSizePoints))
        guard offW > 0, offH > 0 else { return }

        guard let offscreen = CGContext(
            data: nil,
            width: offW,
            height: offH,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return }

        offscreen.setShouldAntialias(false)
        offscreen.interpolationQuality = .none

        // view-space -> offscreen-space
        offscreen.translateBy(x: -rect.minX / pixelSizePoints, y: -rect.minY / pixelSizePoints)
        offscreen.scaleBy(x: 1.0 / pixelSizePoints, y: 1.0 / pixelSizePoints)

        offscreen.addPath(path)
        offscreen.setStrokeColor(strokeColor.cgColor)
        offscreen.setLineWidth(5)      // tune this thickness
        offscreen.setLineCap(.butt)
        offscreen.setLineJoin(.miter)
        offscreen.strokePath()

        guard let img = offscreen.makeImage() else { return }

        context.saveGState()
        context.setShouldAntialias(false)
        context.interpolationQuality = .none
        context.draw(img, in: rect)
        context.restoreGState()
    }
}
