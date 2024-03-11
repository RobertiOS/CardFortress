// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CFHelper",
    platforms: [.iOS(
        "16.1"
    )],
    products: [
        .library(
            name: "CFSharedResources",
            targets: ["CFSharedResources"]
        ),
        .library(
            name: "CFAPIs",
            targets: ["CFAPIs"]
        ),
        .library(
            name: "CFSharedUI",
            targets: ["CFSharedUI"]
        ),
        .library(
            name: "CFFireBase",
            targets: ["CFFireBase"]
        ),
        .library(
            name: "CFDomain",
            targets: ["CFDomain"]
        ),
        .library(
            name: "MockSupport",
            targets: ["MockSupport"]
        )
        
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(
                from: "10.22.1"
            )
        ),
    ],
    targets: [
        .target(
            name: "CFSharedResources",
            path: "Sources/FeatureModules/CFSharedResources",
            resources: [.process(
                "Resources/Process"
            )]
        ),
        .target(
            name: "CFAPIs",
            dependencies: [
                .target(
                    name: "CFSharedResources"
                ),
                .product(
                    name: "FirebaseFirestore",
                    package: "firebase-ios-sdk"
                ),
                .target(name: "CFDomain"),
                .target(name: "CFFireBase")
            ],
            path: "Sources/FeatureModules/CFAPIs"
        ),
        .target(
            name: "CFSharedUI",
            dependencies: [
                .target(
                    name: "CFAPIs"
                ),
                .target(
                    name: "CFSharedResources"
                )
            ],
            path: "Sources/CFSharedUI"
        ),
        .target(
            name: "CFFireBase",
            dependencies: [
                .product(
                    name: "FirebaseFirestore",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseAnalytics",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseAuth",
                    package: "firebase-ios-sdk"
                )
                
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "CFDomain",
            path: "Sources/Domain"
        ),
        .target(
            name: "MockSupport",
            dependencies: [
                .target(name: "CFDomain")
            ],
            path: "Sources/MockSupport"
        ),
        
    ]
)
