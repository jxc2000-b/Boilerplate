//
//  PixelStylePolylineRenderer.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/17/26.
//
import MapKit
import UIKit

/// Fast “pixel-ish” styling for polylines:
/// - disables antialiasing at the CGContext level
/// - uses square caps/joins and optional dash pattern
final class PixelStylePolylineRenderer: MKPolylineRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        context.saveGState()
        context.setShouldAntialias(false)
        context.interpolationQuality = .none
        super.draw(mapRect, zoomScale: zoomScale, in: context)
        context.restoreGState()
    }
}
