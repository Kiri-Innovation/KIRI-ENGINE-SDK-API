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
            url: "https://repository.kiri-engine.com/repository/iOS-SDK/1.1.0/KIRIEngineSDK.xcframework.zip",
            checksum: "a2ca7e2766dc281829b3516355fbeb9ac82885eef51152316e4542d3d6191f0f"
        )
    ]
)
