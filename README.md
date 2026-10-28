# ScratchReveal

[![CI](https://github.com/VasuChovatiya/ScratchReveal/actions/workflows/ci.yml/badge.svg)](https://github.com/VasuChovatiya/ScratchReveal/actions/workflows/ci.yml)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![License](https://img.shields.io/badge/license-MIT-lightgrey)
[![SwiftLint](https://img.shields.io/badge/code_style-SwiftLint-F05138?logo=swift&logoColor=white)](.swiftlint.yml)

A SwiftUI demo of a scratch-card reveal. Drag a finger across the card to scratch off the cover and uncover the prize underneath. The reveal triggers once about 40% of the card is scratched.

[Watch the demo](ScratchReveal-Demo.mp4)

## Features

- Scratch-off cover built on a UIKit scratch view bridged into SwiftUI
- Adjustable brush size
- Live scratch progress and reveal state
- Auto-scratch helper
- Multiple prize cards

## Requirements

- iOS 17.0+ (iPhone and iPad, portrait)
- Xcode 15+ or Swift Playgrounds 4.4+
- Swift 5.9

## Running

Open `Package.swift` in Xcode (or open the folder in Swift Playgrounds) and run the `ScratchReveal` app on a simulator or device.

## Structure

```
Sources/
├── ContentView.swift      # Demo screen: card, brush slider, progress
├── ScratchView.swift      # SwiftUI wrapper around the scratch view
├── AutoScratch.swift      # Automatic scratch animation
├── Resources/             # Scratch cover image
└── ThirdParty/
    └── GLScratchCard/     # GLScratchCardImageView (scratch rendering)
```

## Third-party code

The scratch rendering in `Sources/ThirdParty/GLScratchCard/` comes from [GLScratchCard](https://github.com/gokulgovind/GLScratchCard) by Gokul Govind, MIT licensed. `GLScratchCardImageView.swift` keeps its original header with small local changes, and the cover image `Sources/Resources/scratch_image_new.png` comes from the same project's example app. The upstream license is in [`Sources/ThirdParty/GLScratchCard/LICENSE`](Sources/ThirdParty/GLScratchCard/LICENSE).

## License

MIT, see [LICENSE](LICENSE). Third-party code keeps its own license (see above).
