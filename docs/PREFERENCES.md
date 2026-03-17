# Preferences & Design Decisions

## Aesthetic

- **Pixel art stickers only** — no smooth vector icons, no emoji, no system icons in production
- Crisp nearest-neighbour scaling (`magnificationFilter = .nearest`) — never bilinear
- Stickers should feel like collectible pins placed on a map, not data overlays
- Map base should be a clean, minimal backdrop that makes pixel art pop — not compete with it

## Map Style

- **CartoDB Positron** (`light_nolabels`) — off-white land, soft grey roads, coastlines visible
- No labels of any kind on the base map — all text comes from sticker metadata only
- Positron chosen over Dark Matter because sticker art palette is TBD — light base is safer default
- If Positron proves insufficient, upgrade path is **Stadia Maps** (free tier, account required) or **Mapbox** (most control, account required)

## Tile Provider Preference

1. CartoDB (current) — free, no account, good enough for MVP
2. Stadia Maps — if more style control is needed
3. Mapbox — if full custom style editor is needed

## Zoom Tier Philosophy

- Tiers exist to control **information density** — the map should never feel cluttered
- State/Province tier = one or two stickers representing an entire region, visible when zoomed far out
- City tier = bold, iconic landmarks. One or two per city.
- Neighbourhood tier = venues, parks, local spots
- Street tier = hyper-local, granular detail

## Sticker Sizing Standard

| Tier | Canvas Size | Rendered (points) |
|---|---|---|
| State/Province (planned) | 48x48px | 48x48pt |
| City | 32x32px | 32x32pt |
| Neighbourhood | 24x24px | 24x24pt |
| Street | 16x16px | 16x16pt |

- Always draw at base canvas size and export @1x @2x @3x
- Recommended tools: Piskel (free, browser), Aseprite (paid, best in class)

## Architecture Preferences

- SwiftUI shell, UIKit map internals (UIViewRepresentable) — correct tradeoff for MapKit control
- `MapViewModel` as single ObservableObject — no split view models for now
- `StickerStore` as a simple singleton with a hardcoded array — no CoreData, no JSON, no backend yet
- Unlock conditions designed to be extensible — `.zoom` is active, `.proximity` / `.time` / `.manual` are stubbed

## Code Style

- No force unwraps in production paths
- SF Symbol fallback for missing assets during development — never ship with missing assets
- Simulator warnings (CAMetalLayer, TiledGEOResourceFetcher, satellite@3x.styl) are known and ignorable
