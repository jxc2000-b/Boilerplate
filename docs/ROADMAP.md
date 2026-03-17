# Roadmap

## Immediate Next Steps

- [ ] Add `.state` / `.province` tier to `StickerTier.swift` — renders at `latitudeDelta < 5.0`, 48x48pt art
- [ ] Add real pixel art assets for Bank of America Plaza and Mercedes-Benz Stadium to asset catalog
- [ ] Add `NSLocationWhenInUseUsageDescription` to `Info.plist`
- [ ] Implement `PermissionManager` for real user location and wire into `CurrentLocationButton` and `UnlockContext`

## Short Term

- [ ] Add more Atlanta stickers across all tiers
- [ ] Style `StickerDetailSheet` properly — fonts, colours, layout polish
- [ ] Add `DiscoveryGlowView` — pulsing glow on stickers with `hasHiddenDepth: true`
- [ ] Handle sticker overlap — evaluate tier separation first, then MapKit clustering if needed

## Medium Term

- [ ] Sticker overlap / clustering system — MapKit `MKClusterAnnotation` styled to match pixel art aesthetic
- [ ] Animated stickers — sprite sheet and/or Lottie support in `StickerAnnotationView`
- [ ] Consider Stadia Maps or Mapbox if CartoDB style customisation proves insufficient
- [ ] Expand sticker unlock conditions — proximity (`CLLocation`), time-based, manual unlock

## Long Term / Post-MVP

- [ ] Dynamic sticker loading from backend / JSON — replace hardcoded `StickerStore`
- [ ] Multi-city support — stickers beyond Atlanta
- [ ] User accounts and personalisation
- [ ] Social features — sticker discovery feeds, sharing
- [ ] App Store submission prep — icons, launch screen, privacy policy

## Known Issues / Technical Debt

- `userLocation` in `UnlockContext` is always `nil` — proximity unlocks will silently never fire until PermissionManager is implemented
- `CurrentLocationButton` jumps to hardcoded Atlanta coordinate — not real user location
- `mapType = .satellite` used as base to suppress Apple labels — produces simulator warnings (`satellite@3x.styl`) which are harmless but noisy
- No error handling on CartoDB tile fetch failures — tiles silently fail to load on no network
