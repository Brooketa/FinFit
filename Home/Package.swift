// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Home",
    defaultLocalization: "en",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Home", targets: ["Home"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../CoreUI"),
        .package(url: "https://github.com/hmlongco/Factory", exact: "3.5.1")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                "Core",
                "CoreUI",
                .product(name: "FactoryKit", package: "Factory")
            ],
            resources: [.process("Resources")])
    ]
)
