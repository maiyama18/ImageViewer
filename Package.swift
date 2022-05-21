// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageViewer",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "ImageViewer",
            targets: ["ImageViewer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ImageViewer",
            dependencies: []),
        .testTarget(
            name: "ImageViewerTests",
            dependencies: ["ImageViewer"]),
    ]
)
