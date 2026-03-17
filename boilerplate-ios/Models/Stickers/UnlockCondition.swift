//
//  UnlockCondition.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import Foundation
import CoreLocation

enum UnlockCondition: Equatable {
    case zoom(belowLatitudeDelta: Double) // MVP — zoom based( Params for zoom based unlock rules i guess)
    case zoomRange(maxLatitudeDelta: Double, minLatitudeDelta: Double?) // Option B — visible between two zoom levels
    case proximity(radiusMeters: Double) // future — near location IRL
    case time(after: Date) // future — time based reveal
    case manual(id: String) // future — explicit app unlock, I Lyk this
    
    // Equatable conformance (auto-synthesis can't handle optional Double in associated values reliably)
    static func == (lhs: UnlockCondition, rhs: UnlockCondition) -> Bool {
        switch (lhs, rhs) {
        case (.zoom(let a), .zoom(let b)):
            return a == b
        case (.zoomRange(let aMax, let aMin), .zoomRange(let bMax, let bMin)):
            return aMax == bMax && aMin == bMin
        case (.proximity(let a), .proximity(let b)):
            return a == b
        case (.time(let a), .time(let b)):
            return a == b
        case (.manual(let a), .manual(let b)):
            return a == b
        default:
            return false
        }
    }

    // Evaluate whether this condition is currently met
    func isMet(context: UnlockContext) -> Bool {
        switch self {
        case .zoom(let threshold):
            return context.currentLatitudeDelta < threshold
        case .zoomRange(let maxDelta, let minDelta):
            // Visible when zoomed in enough (delta < max) and not too zoomed in (delta >= min, if set)
            let delta = context.currentLatitudeDelta
            return delta < maxDelta && minDelta.map { delta >= $0 } ?? true
        case .proximity(let radius):
            guard let userLocation = context.userLocation,
                  let stickerLocation = context.stickerLocation else { return  false }
            return userLocation.distance(from: stickerLocation) < radius
        case .time(let date):
            return Date() >= date
        case .manual(let id):
            return context.manuallyUnlockedIds.contains(id)
        }
    }
}
// zoom must

enum UnlockRequirement {
    case all //all conditions must pass
    case any //at least one condition must pass
}

struct StickerUnlockRule {
    var conditions: [UnlockCondition]
    var requirement: UnlockRequirement
    
    func isUnlocked(isUnlockedContext: UnlockContext) -> Bool {
        switch requirement {
        case .all:
            return conditions.allSatisfy{
               ($0.isMet(context: isUnlockedContext))
            }
            //        for condition in conditions {
            //            if !condition.isMet(context: isUnlockedContext) {
            //                return false
            //            }
            //        }
            //        return true
        case .any:
            return conditions.contains{
                $0.isMet(context: isUnlockedContext)
            }
        }

    }
}

// All the runtime information needed to evaluate unlock conditions
struct UnlockContext {
    var currentLatitudeDelta: Double
    var userLocation: CLLocation?
    var stickerLocation: CLLocation?
    var manuallyUnlockedIds: Set<String>
}
