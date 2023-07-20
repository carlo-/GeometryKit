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
            ]
        ),
        .target(
            name: "AGGeometryKit",
            dependencies: [],
            publicHeadersPath: "Public"
        )
    ]
)
