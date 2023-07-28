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
            url: "https://repository.kiri-engine.com/repository/iOS-SDK/1.1.2/KIRIEngineSDK.xcframework.zip",
            checksum: "431c085a52e7722eb3b5ab1cb5f7530c2e2498eb5c5672c5de59c5c05bb8fab3"
        )
    ]
)
