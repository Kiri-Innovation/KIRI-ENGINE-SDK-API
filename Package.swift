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
            checksum: "581e250d7b63877c6f28d5eec1ff62b668034904f51906fcd8f68bfd21d33ddc"
        )
    ]
)
