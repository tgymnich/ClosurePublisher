# ClosurePublisher

Combine Publisher for closure results


# Usage

// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "MyTool",
  dependencies: [
    .package(url: "https://github.com/TG908/ClosurePublisher.git", .from: "0.0.1"),
  ],
  targets: [
    .target(name: "MyTool", dependencies: ["ClosurePublisher"]),
  ]
)
