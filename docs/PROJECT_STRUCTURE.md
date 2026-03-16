# Project Structure

## Entry Points

| File | Purpose |
|---|---|
| `boilerplate_iosApp.swift` | `@main` app struct — launches directly into `AppRootView` |
| `AppRootView.swift` | Root SwiftUI view — currently points straight to `MapView` for MVP testing |

## Core Models (`Core/Models/`)

| File | Purpose |
|---|---|
| `Sticker.swift` | Master sticker model — id, coordinate, asset, tier, unlockRule, detail |
| `StickerTier.swift` | Enum for zoom tiers: `.city`, `.neighbourhood`, `.street` — each has a `latitudeDeltaThreshold` |
| `StickerAsset.swift` | Art config per sticker — imageName, size, animationType, isPixelArt |
| `StickerDetail.swift` | Tap-sheet metadata — title, description, category, actionLabel, actionURL, address, dateRange |
| `UnlockCondition.swift` | Unlock rule system — `.zoom`, `.proximity`, `.time`, `.manual` conditions with `StickerUnlockRule` |

## Data Layer (`Core/Data/`)

| File | Purpose |
|---|---|
| `StickerStore.swift` | Single source of truth — all hardcoded stickers live here. Currently: Bank of America Plaza + Mercedes-Benz Stadium in Atlanta |

## Map Layer (`Map/Core/`)

| File | Purpose |
|---|---|
| `MapView.swift` | Top-level SwiftUI map screen — composes AppMapView, CurrentLocationButton, ZoomHintView, StickerDetailSheet |
| `MapViewModel.swift` | ObservableObject — manages region, zoom delta, visible stickers, selected sticker, hint stickers |
| `AppMapView.swift` | UIViewRepresentable — bridges SwiftUI to MKMapView. Handles annotation sync, region sync, delegate |
| `StickerAnnotation.swift` | MKAnnotation subclass — wraps a Sticker for MapKit |
| `StickerAnnotationView.swift` | MKAnnotationView subclass — renders pixel art pin with spring pop-in animation. Falls back to SF Symbol if asset missing |

## Overlays (`Map/Overlays/`)

| File | Purpose |
|---|---|
| `MapTileOverlay.swift` | MKTileOverlay subclass — serves CartoDB Positron label-free tiles. Includes NSCache tile caching |

## Components (`Map/Components/`)

| File | Purpose |
|---|---|
| `CurrentLocationButton.swift` | Location jump button — hardcoded to Atlanta centre for MVP |
| `ZoomHintView.swift` | Pill hint view — appears when hintStickers is non-empty, prompts user to zoom in |

## Detail Sheet (`Map/Detail/`)

| File | Purpose |
|---|---|
| `StickerDetailSheet.swift` | Bottom sheet shown on sticker tap — shows title, category, description, address, date range, action button |

## Utilities (`Utilities/`)

| File | Purpose |
|---|---|
| `ZoomLevel.swift` | Static helpers — `tier(for:)` and `isZoomedIn(forTier:latitudeDelta:)` |

## Folder Layout

```
boilerplate-ios/
├── boilerplate_iosApp.swift
├── AppRootView.swift
├── Core/
│   ├── Models/
│   │   ├── Sticker.swift
│   │   ├── StickerTier.swift
│   │   ├── StickerAsset.swift
│   │   ├── StickerDetail.swift
│   │   └── UnlockCondition.swift
│   └── Data/
│       └── StickerStore.swift
├── Map/
│   ├── Core/
│   │   ├── MapView.swift
│   │   ├── MapViewModel.swift
│   │   ├── AppMapView.swift
│   │   ├── StickerAnnotation.swift
│   │   └── StickerAnnotationView.swift
│   ├── Overlays/
│   │   └── MapTileOverlay.swift
│   ├── Components/
│   │   ├── CurrentLocationButton.swift
│   │   └── ZoomHintView.swift
│   └── Detail/
│       └── StickerDetailSheet.swift
└── Utilities/
    └── ZoomLevel.swift
```