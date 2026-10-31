// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Tiny11BuilderMac",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "Tiny11Core", targets: ["Tiny11Core"]),
        .executable(name: "Tiny11BuilderMac", targets: ["Tiny11BuilderApp"])
    ],
    targets: [
        .target(
            name: "CHivex",
            path: "Sources/CHivex",
            publicHeadersPath: "include",
            linkerSettings: [
                .unsafeFlags([
                    "-L/opt/homebrew/opt/hivex/lib",
                    "-lhivex",
                    "-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks",
                    "-Xlinker", "-rpath", "-Xlinker", "/opt/homebrew/opt/hivex/lib"
                ])
            ]
        ),
        .target(
            name: "Tiny11Core",
            dependencies: ["CHivex"],
            path: "Sources/Tiny11Core"
        ),
        .executableTarget(
            name: "Tiny11BuilderApp",
            dependencies: ["Tiny11Core"],
            path: "Sources/Tiny11BuilderApp"
        ),
        .testTarget(
            name: "Tiny11CoreTests",
            dependencies: ["Tiny11Core", "CHivex"],
            path: "Tests/Tiny11CoreTests"
        )
    ]
)
