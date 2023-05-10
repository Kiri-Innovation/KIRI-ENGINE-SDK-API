// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KIRIEngineSDK",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "KIRIEngineSDK", targets: ["KIRIEngineSDK"])
    ],
    dependencies: [
        
    ],
    targets: [
        .binaryTarget(
            name: "KIRIEngineSDK",
            url: "https://repository.kiri-engine.com/repository/iOS-SDK/1.0.0/KIRIEngineSDK.xcframework.zip",
            checksum: "570da37fd03062161bd10ad5ec1f9b105b0a6226cbe2cb736f09dc44f9d66bcd"
        )
    ]
)
