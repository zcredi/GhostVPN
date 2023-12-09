//
//  HomeInteractorTests.swift
//  GhostVPNTests
//
//  Created by Владислав on 08.12.2023.
//

import XCTest
import LocationService
import VPNManager
@testable import HomeScene

final class HomeInteractorTests: XCTestCase {
    
    private var sut: HomeInteractor!
    private var mockVPN: MockVPN!
    private var mockLocationServes: MockLocationServes!
    
    override func setUp() async throws {
        try await super.setUp()
        mockVPN = MockVPN()
        mockLocationServes = MockLocationServes()
        sut = HomeInteractor(vpnManager: mockVPN, locationService: mockLocationServes)
    }
    
    override func tearDown() async throws {
        sut = nil
        mockVPN = nil
        mockLocationServes = nil
        try await super.tearDown()
    }
    
    func test_connectToVpnRequested() {
        sut.connectToVPN()
        XCTAssertTrue(mockVPN.isRequested)
    }
    
}

private extension HomeInteractorTests {
    class MockVPN: VPNManagerProtocol {
        private (set) var isRequested = false
        
        func connectToVPN(_ serverInfo: VPNManager.ServerInfo, completion: @escaping (Error?) -> Void) {
            isRequested = true
        }
        
        func disconnectFromVPN() {
            isRequested = false
        }
    }
    
    class MockLocationServes: LocationService {
        func currentLocation() {
           
        }
    }
    
//    func makeSut() -> HomeInteractor {
//        HomeInteractor(vpnManager: MokVPN(), locationService: MokLocationServes())
//    }
}
