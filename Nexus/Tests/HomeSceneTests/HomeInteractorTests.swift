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
    private var mockPresenter: MockPresenter!
    
    override func setUp() async throws {
        try await super.setUp()
        mockVPN = MockVPN()
        mockLocationServes = MockLocationServes()
        sut = HomeInteractor(vpnManager: mockVPN, locationService: mockLocationServes)
        mockPresenter = MockPresenter()
        sut.presenter = mockPresenter
    }
    
    override func tearDown() async throws {
        sut = nil
        mockVPN = nil
        mockLocationServes = nil
        try await super.tearDown()
    }
    
    func test_connectToVPN_VPNServiceRequested() {
        sut.connectToVPN()
        
        XCTAssertTrue(mockVPN.isRequested)
    }
    
    func test_connectToVPN_EndWithSuccess() {
        sut.connectToVPN()
        
        XCTAssertEqual(mockPresenter.state, [.loading, .success])
    }
    
    func test_connectToVPN_EndWithError() {
        let error = URLError(.badURL)
        mockVPN.error = error
        
        sut.connectToVPN()
        
        XCTAssertEqual(mockPresenter.state, [.loading, .error(error)])
    }
    
    
}

private extension HomeInteractorTests {
    
    class MockPresenter: HomePresentationLogic {
        private(set) var state: [ConnectionState] = .init()
        
        func connectionState(_ state: HomeScene.ConnectionState) {
            self.state.append(state)
        }
    }
    
    class MockVPN: VPNManagerProtocol {
        var error: Error?
        private (set) var isRequested = false
        
        func connectToVPN(_ serverInfo: VPNManager.ServerInfo, completion: @escaping (Error?) -> Void) {
            isRequested = true
            if let error {
                completion(error)
                return
            }
            completion(nil)
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
