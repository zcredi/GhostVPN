// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//MARK: - Package
let package = Package(
    name: "Nexus",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        Dependencies.VPNManager.library,
        Dependencies.ServerProvider.library,
        Dependencies.LocationService.library,
        Dependencies.TimeService.library,
        .library(name: "Nexus",targets: ["Nexus"]),
        .library(name: "HomeScene", targets: ["HomeScene"]),
    ],
    targets: [
        Dependencies.LocationService.targer,
        Dependencies.VPNManager.targer,
        Dependencies.ServerProvider.targer,
        Dependencies.TimeService.targer,
        .target(name: "Nexus"),
        .target(
            name: "HomeScene",
            dependencies: [
                Dependencies.LocationService.dependency,
                Dependencies.VPNManager.dependency,
                Dependencies.ServerProvider.dependency,
                Dependencies.TimeService.dependency
            ]),
        .testTarget(
            name: "NexusTests",
            dependencies: ["Nexus"]),
        .testTarget(
            name: "HomeSceneTests",
            dependencies: [
                Dependencies.LocationService.dependency,
                Dependencies.VPNManager.dependency,
                Dependencies.ServerProvider.dependency,
                "HomeScene"
            ])
    ]
)

//MARK: - Dependencies
fileprivate enum Dependencies {
    case VPNManager
    case ServerProvider
    case LocationService
    case TimeService
    
    var library: Product {
        switch self {
        case .VPNManager: return .library(name: "VPNManager", targets: ["VPNManager"])
        case .ServerProvider: return .library(name: "ServerProvider", targets: ["ServerProvider"])
        case .LocationService: return .library(name: "LocationService", targets: ["LocationService"])
        case .TimeService: return .library(name: "TimeService", targets: ["TimeService"])
        }
    }
    
    var targer: Target {
        switch self {
        case .VPNManager: return .target(name: "VPNManager")
        case .ServerProvider: return .target(name: "ServerProvider")
        case .LocationService: return .target(name: "LocationService")
        case .TimeService: return .target(name: "TimeService")
        }
    }
    
    var dependency: Target.Dependency {
        switch self {
        case .VPNManager: return "VPNManager"
        case .ServerProvider: return "ServerProvider"
        case .LocationService: return "LocationService"
        case .TimeService: return "TimeService"
        }
    }
}
