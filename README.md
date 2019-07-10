# ClosurePublisher

Simple publisher you can use to publish the result of a closure.
```
let publisher = Publishers.Closure(closure: { return 1 } 
```

# Usage
```
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
```
