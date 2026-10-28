// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "CoreUI", targets: ["CoreUI"])
    ],
    targets: [
        .target(
            name: "CoreUI",
            resources: [.process("Resources")])
    ]
)
