// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "HealthCheck",
    defaultLocalization: "en",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "HealthCheck", targets: ["HealthCheck"])
    ],
    dependencies: [
        .package(name: "CoreUI", path: "../CoreUI"),
        .package(url: "https://github.com/hmlongco/Factory", exact: "3.5.1")
    ],
    targets: [
        .target(
            name: "HealthCheck",
            dependencies: [
                "CoreUI",
                .product(name: "FactoryKit", package: "Factory")
            ],
            resources: [.process("Resources")])
    ]
)
