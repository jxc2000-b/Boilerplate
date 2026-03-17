# Pixel-Map Stickers App

A SwiftUI+UIKit map application for showcasing hand-curated pixel-art stickers at different zoom levels, focused on Atlanta landmarks.

## Overview

- **Map**: Custom tile overlay (CartoDB Positron, label-free) with full pan/zoom, user location, no default Apple labels/icons.
- **Stickers**: Hardcoded pixel stickers at various zoom tiers, each with art, location, and metadata.
- **Zoom Tiers**: Stickers unlock at specific zoom levels, from hyper-local ("street tier") up to big landmarks ("city tier").
- **No game mechanics, discovery, or reward system**: Stickers are informational, not gamified.
- **No Apple POIs, labels, or icons**: Custom art only.
- **MVP currently scoped to Atlanta.**

## Tech Stack

- Swift / SwiftUI + UIKit (UIViewRepresentable bridge)
- MapKit (MKMapView, MKAnnotation, MKTileOverlay)
- CartoDB Positron tile set (label-free)
- Xcode asset catalog for pixel art assets

## Project Docs

- [Project Structure](docs/PROJECT_STRUCTURE.md)
- [Requirements](docs/REQUIREMENTS.md)
- [Preferences & Design Decisions](docs/PREFERENCES.md)
- [Roadmap](docs/ROADMAP.md)