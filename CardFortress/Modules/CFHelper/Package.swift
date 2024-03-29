// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CFHelper",
    platforms: [.iOS("16.1")],
    products: [
        .library(
            name: "CFSharedResources",
            targets: ["CFSharedResources"]),
        .library(
            name: "CFAPIs",
            targets: ["CFAPIs"]),
        .library(
            name: "CFSharedUI",
            targets: ["CFSharedUI"]),
        
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CFSharedResources",
            path: "Sources/FeatureModules/CFSharedResources",
            resources: [.process("Resources/Process")]
        ),
        .target(
            name: "CFAPIs",
            dependencies: [.target(name: "CFSharedResources")],
            path: "Sources/FeatureModules/CFAPIs"
        ),
        .target(
            name: "CFSharedUI",
            dependencies: [.target(name: "CFAPIs"), .target(name: "CFSharedResources")],
            path: "Sources/CFSharedUI"
        )
    ]
)
