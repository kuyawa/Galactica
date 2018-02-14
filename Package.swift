import PackageDescription

let package = Package(
    name: "Galactica",
    dependencies: [
        .package(url: "https://github.com/kuyawa/StellarSDK.git", .exact("1.0"))  // Swift 3.2
    ]
)