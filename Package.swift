// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleSubtitles",
    platforms: [.tvOS(.v12), .iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SimpleSubtitles",
            targets: ["SimpleSubtitles"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SimpleSubtitles",
            dependencies: ["SubtitlesInterface"]),
        .target(
            name: "SubtitlesInterface",
            dependencies: []),
        .testTarget(
            name: "SimpleSubtitles-Test",
            dependencies: ["SimpleSubtitles", "SubtitlesInterface"]),
    ]
)
