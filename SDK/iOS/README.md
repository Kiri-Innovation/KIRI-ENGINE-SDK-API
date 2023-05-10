## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate KIRIEngineSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'KIRIEngineSDK'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding KIRIEngineSDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/Kiri-Innovation/KIRI-ENGINE-SDK-API.git", branch: "ios")
]
```

## Features

- [Usage](Usage.md)
    - [**BasicCamera**](Usage.md#BasicCamera)
    - [**AdvanceCamera**](Usage.md#AdvanceCamera)
    - [**3DModelDisplay**](Usage.md#3DModelDisplay)