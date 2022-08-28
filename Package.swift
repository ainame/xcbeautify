// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "xcbeautify",
    products: [
        .executable(name: "xcbeautify", targets: ["xcbeautify"]),
        .library(name: "XcbeautifyLib", targets: ["XcbeautifyLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.1"),
        .package(url: "https://github.com/getGuaka/Colorizer.git", from: "0.1.0"),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.13.1"),
    ],
    targets: [
        .target(
            name: "XcbeautifyLib",
            dependencies: [
                "Colorizer",
                "XMLCoder"
            ],
            swiftSettings: [
              .unsafeFlags(["-Xfrontend", "-enable-bare-slash-regex"]),
              .unsafeFlags(["-Xfrontend", "-enable-experimental-string-processing"]),
              .unsafeFlags(["-Xfrontend", "-disable-availability-checking"]),
              .unsafeFlags(["-sdk", "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"]),
            ]
        ),
        .target(
            name: "xcbeautify",
            dependencies: [
                "XcbeautifyLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "XcbeautifyLibTests",
            dependencies: ["XcbeautifyLib"]
        ),
    ]
)
