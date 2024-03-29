// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MAcOSAccessibilityHierarchyOverview",
        platforms: [
            .macOS("12.0")
        ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "MacOSAccessibilityApplicationWrapper", url: "https://github.com/savoptik/MacOSAccessibilityApplicationWrapper.git", .branch("v1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "MAcOSAccessibilityHierarchyOverview",
            dependencies: ["MacOSAccessibilityApplicationWrapper"]),
        .testTarget(
            name: "MAcOSAccessibilityHierarchyOverviewTests",
            dependencies: ["MAcOSAccessibilityHierarchyOverview"]),
    ]
)
