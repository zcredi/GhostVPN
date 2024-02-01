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
        .library(name: "Nexus", targets: ["Nexus"]),
        .library(name: "HomeScene", targets: ["HomeScene"]),
        Dependencies.VPNManager.library,
        Dependencies.ServerProvider.library,
        Dependencies.LocationService.library,
        Dependencies.TimeService.library,
        Dependencies.CommonServices.library,
        Dependencies.TimeFormatting.library,
    ],
    targets: [
        Dependencies.VPNManager.target,
        Dependencies.ServerProvider.target,
        Dependencies.LocationService.target,
        Dependencies.TimeService.target,
        Dependencies.CommonServices.target,
        Dependencies.TimeFormatting.target,
        .target(name: "Nexus"),
        .target(
            name: "HomeScene",
            dependencies: [Dependencies.VPNManager.dependency,
                           Dependencies.ServerProvider.dependency,
                           Dependencies.LocationService.dependency,
                           Dependencies.TimeService.dependency,
                           Dependencies.CommonServices.dependency,
                           Dependencies.TimeFormatting.dependency]),
        .testTarget(
            name: "NexusTests",
            dependencies: ["Nexus"]),
        .testTarget(
            name: "HomeSceneTests",
            dependencies: [Dependencies.VPNManager.dependency,
                           Dependencies.ServerProvider.dependency,
                           Dependencies.LocationService.dependency,
                           Dependencies.TimeService.dependency,
                           Dependencies.CommonServices.dependency,
                           Dependencies.TimeFormatting.dependency,
                           "HomeScene"]),
    ]
)

//MARK: - Dependencies
fileprivate enum Dependencies {
    case VPNManager
    case ServerProvider
    case LocationService
    case TimeService
    case CommonServices
    case TimeFormatting
    
    var library: Product {
        switch self {
        case .VPNManager: return .library(name: "VPNManager", targets: ["VPNManager"])
        case .ServerProvider: return .library(name: "ServerProvider", targets: ["ServerProvider"])
        case .LocationService: return .library(name: "LocationService", targets: ["LocationService"])
        case .TimeService: return .library(name: "TimeService", targets: ["TimeService"])
        case .CommonServices: return .library(name: "CommonServices", targets: ["CommonServices"])
        case .TimeFormatting: return .library(name: "TimeFormatting", targets: ["TimeFormatting"])
        }
    }
    
    var target: Target {
        switch self {
        case .VPNManager: return .target(name: "VPNManager")
        case .ServerProvider: return .target(name: "ServerProvider")
        case .LocationService: return .target(name: "LocationService")
        case .TimeService: return .target(name: "TimeService")
        case .CommonServices: return .target(name: "CommonServices")
        case .TimeFormatting: return .target(name: "TimeFormatting")
        }
    }
    
    var dependency: Target.Dependency {
        switch self {
        case .VPNManager: return "VPNManager"
        case .ServerProvider: return "ServerProvider"
        case .LocationService: return "LocationService"
        case .TimeService: return "TimeService"
        case .CommonServices: return "CommonServices"
        case .TimeFormatting: return "TimeFormatting"
        }
    }
}
