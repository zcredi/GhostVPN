//
//  HomeInteractorTests.swift
//  GhostVPNTests
//
//  Created by Владислав on 08.12.2023.
//

import XCTest
@testable import GhostVPN

final class HomeInteractorTests: XCTestCase {
    
    private var sut: HomeInteractor!
    private var mokVPN: MokVPN!
    private var mokLocationServes: MokLocationServes!
    
    override func setUp() async throws {
        try await super.setUp()
        mokVPN = MokVPN()
        mokLocationServes = MokLocationServes()
        sut = HomeInteractor(vpnManager: mokVPN, locationService: mokLocationServes)
    }
    
    override func tearDown() async throws {
        sut = nil
        mokVPN = nil
        mokLocationServes = nil
        try await super.tearDown()
    }
    
    func test_connectToVpnRequested() {
        sut.connectToVPN()
        XCTAssertTrue(mokVPN.isRecvested)
    }
    
}

private extension HomeInteractorTests {
    class MokVPN: VPNManagerProtocol {
        private (set) var isRecvested = false
        
        func connectToVPN(serverInfo: GhostVPN.VPNServerInfo, completion: @escaping (Error?) -> Void) {
            isRecvested = true
        }
        
        func disconnectFromVPN(completion: @escaping (Error?) -> Void) {
            isRecvested = false
        }
    }
    
    class MokLocationServes: LocationService {
        func currentLocation() -> GhostVPN.VPNServerInfo {
            .init(ip: "bus", security: Security(vpn: true, proxy: true, tor: true, relay: true), location: Location(city: "bus", region: "bus", country: "bus", continent: "bus", regionCode: "bus", countryCode: "bus", continentCode: "bus", latitude: "bus", longitude: "bus", timeZone: "bus", localeCode: "bus", metroCode: "bus", isInEuropeanUnion: true), network: Network(network: "bus", autonomousSystemNumber: "bus", autonomousSystemOrganization: "bus"))
        }
    }
    
    func makeSut() -> HomeInteractor {
        HomeInteractor(vpnManager: MokVPN(), locationService: MokLocationServes())
    }
}
