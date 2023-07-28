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
            url: "https://repository.kiri-engine.com/repository/iOS-SDK/1.1.1/KIRIEngineSDK.xcframework.zip",
            checksum: "90edddab07b271d82d39483f5d5a4ec9371777e0c20a9324b877c7b0c399654a"
        )
    ]
)
