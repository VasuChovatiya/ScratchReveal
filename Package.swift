// swift-tools-version: 5.9
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "ScratchReveal",
    platforms: [.iOS("17.0")],
    products: [
        .iOSApplication(
            name: "ScratchReveal",
            targets: ["App"],
            bundleIdentifier: "com.demo.ScratchReveal",
            displayVersion: "1.0",
            bundleVersion: "1",
            supportedDeviceFamilies: [.phone, .pad],
            supportedInterfaceOrientations: [.portrait]
        )
    ],
    targets: [
        .executableTarget(name: "App", path: "Sources", resources: [.process("Resources")])
    ]
)
