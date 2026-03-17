//
//  MapTileOverlay.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/15/26.
//

import MapKit

class MapTileOverlay: MKTileOverlay {

    // CartoDB Positron tile URL template
    // {z} = zoom level, {x} = tile column, {y} = tile row
    static let cartoPositronTemplate =
    "https://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}@2x.png"

    init() {
        super.init(urlTemplate: MapTileOverlay.cartoPositronTemplate)
        self.canReplaceMapContent = true  // 👈 hides Apple's default tiles completely
        self.tileSize = CGSize(width: 512, height: 512)  // @2x tiles are 512px
        self.minimumZ = 0
        self.maximumZ = 19
    }

    // Optional: cache tiles to avoid re-fetching on every pan/zoom
    override func loadTile(
        at path: MKTileOverlayPath,
        result: @escaping (Data?, Error?) -> Void
    ) {
        let url = self.url(forTilePath: path)
        let cacheKey = "\(path.z)-\(path.x)-\(path.y)" as NSString

        // Check memory cache first
        if let cached = TileCache.shared.object(forKey: cacheKey) {
            result(cached as Data, nil)
            return
        }

        // Fetch from network
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                TileCache.shared.setObject(data as NSData, forKey: cacheKey)
            }
            result(data, error)
        }.resume()
    }
}

// Simple in-memory tile cache
private class TileCache {
    static let shared = NSCache<NSString, NSData>()
}
