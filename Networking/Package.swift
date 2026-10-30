// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Networking", targets: ["Networking"])
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", exact: "3.5.1")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory")
            ]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"])
    ]
)
