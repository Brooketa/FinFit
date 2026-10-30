// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", exact: "3.5.1")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory")
            ]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"])
    ]
)
