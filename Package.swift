// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "geometry-kit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GeometryKit",
            targets: ["GeometryKit", "AGGeometryKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GeometryKit",
            dependencies: [
                "AGGeometryKit"
            ],
            path: "Sources/Swift/"
        ),
        .target(
            name: "AGGeometryKit",
            path: "Sources/Objective-C/",
            publicHeadersPath: "Include"
        )
    ]
)
