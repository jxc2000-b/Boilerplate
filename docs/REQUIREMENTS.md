# Requirements

## Map

- Custom CartoDB Positron tile overlay (`light_nolabels` variant) replaces all Apple map tiles
- Base map type set to `.satellite` so Apple vector labels have nothing to render on
- Tile overlay uses `level: .aboveLabels` to fully bury any Apple labels
- No Apple POIs, city names, road labels, highway signs, landmark names — zero
- Coastlines, region borders, and road networks are preserved (supplied by CartoDB tiles)
- Full pan and zoom freedom — map never snaps back or fights user gestures
- User location blue dot shown on map
- `NSLocationWhenInUseUsageDescription` must be set in Info.plist

## Stickers

- All stickers hardcoded in `StickerStore.swift` — no backend for MVP
- Each sticker has: coordinate, pixel art asset, zoom tier, unlock rule, and detail metadata
- Stickers appear via spring pop-in animation when they become visible
- Stickers disappear when zoomed back out past their tier threshold
- Tapping a sticker opens `StickerDetailSheet` as a bottom sheet

## Zoom Tier System

- `.state` / `.province` — visible at `latitudeDelta < 5.0` — regional stickers (48x48pt) — PLANNED
- `.city` — visible at `latitudeDelta < 1.0` — large landmark stickers (32x32pt)
- `.neighbourhood` — visible at `latitudeDelta < 0.05` — venue stickers (24x24pt)
- `.street` — visible at `latitudeDelta < 0.01` — hyper-local stickers (16x16pt)

## Pixel Art Assets

- All sticker images stored in Xcode asset catalog (`Assets.xcassets`)
- Base canvas sizes: 32x32 (city), 24x24 (neighbourhood), 16x16 (street)
- Export at @1x, @2x, @3x — pixel art tools (Piskel, Aseprite) handle this
- `isPixelArt: true` in `StickerAsset` enables nearest-neighbour rendering (`magnificationFilter = .nearest`)
- Missing assets fall back to coloured SF Symbol (`mappin.circle.fill`) for development

## Current Hardcoded Values (MVP)

- Map opens centred on Atlanta: `33.7490, -84.3880`, `latitudeDelta: 0.5`
- User location hardcoded to Atlanta centre in `CurrentLocationButton.swift`
- `userLocation` in `UnlockContext` is `nil` — proximity unlocks not active yet

## Explicitly Out of Scope for MVP

- No user authentication or accounts
- No backend or dynamic sticker loading
- No social features
- No gamification, collectibles, or reward mechanics
- No user-generated sticker placement
- No sticker overlap / clustering handling (architecture is ready for it)