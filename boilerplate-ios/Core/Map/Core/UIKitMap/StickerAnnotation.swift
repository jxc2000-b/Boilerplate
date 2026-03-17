//
//  StickerAnnotation.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/13/26.
//

import MapKit

class StickerAnnotation: NSObject, MKAnnotation, Identifiable {
    let sticker: Sticker
    var id: String{ sticker.id }
    
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        sticker.coordinate
    }
    
    init(sticker: Sticker) {
        self.sticker = sticker
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? StickerAnnotation else { return false }
        return id == other.id
    }
    
    override var hash: Int {id.hashValue}
}
