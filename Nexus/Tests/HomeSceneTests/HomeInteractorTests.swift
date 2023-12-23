//
//  HomeInteractorTests.swift
//  GhostVPNTests
//
//  Created by Владислав on 08.12.2023.
//

import XCTest
import LocationService
import VPNManager
import TimeService
@testable import HomeScene

final class HomeInteractorTests: XCTestCase {
    private var sut: HomeInteractor!
    private var mockVPN: MockVPN!
    private var mockLocationServes: MockLocationServes!
    private var mockPresenter: MockPresenter!
    private var mockTimer: MockTimer!
    
    override func setUp() async throws {
        try await super.setUp()
        mockVPN = MockVPN()
        mockLocationServes = MockLocationServes()
        mockTimer = .init()
        sut = HomeInteractor(
            vpnManager: mockVPN,
            locationService: mockLocationServes,
            timeService: mockTimer
        )
        mockPresenter = MockPresenter()
        sut.presenter = mockPresenter
    }
    
    override func tearDown() async throws {
        sut = nil
        mockVPN = nil
        mockLocationServes = nil
        mockPresenter = nil
        mockTimer = nil
        try await super.tearDown()
    }
    
    func test_connectToVPN_ServiceRequested() {
        sut.presenter = mockPresenter
        sut.connectToVPN()
        
        XCTAssertTrue(mockVPN.isRequested)
    }
    
    func test_connectToVPN_EndWithSuccess() {
        sut.connectToVPN()
        
        XCTAssertEqual(mockPresenter.state, [.loading, .connected])
    }
    
    func test_connectToVPN_EndWithError() {
        let error = URLError(.badURL)
        mockVPN.error = error
        
        sut.connectToVPN()
        
        XCTAssertEqual(mockPresenter.state, [.loading, .error(error)])
    }
    
    func test_disconnectToVPN() {
        mockPresenter.state = []
        
        sut.disconnectFromVPN()
        
        XCTAssertTrue(mockVPN.isRequested)
        XCTAssertEqual(mockPresenter.state.last, .disconnected)
    }
    
    func test_connectToVPN_startsTimer() {
        sut.connectToVPN()
        
        XCTAssertTrue(mockTimer.isStarted)
        
    }
    
    func test_connectToVPNFailed_doesntStartTimer() {
        let error = URLError(.badURL)
        mockVPN.error = error
        
        sut.connectToVPN()
        
        XCTAssertFalse(mockTimer.isStarted)
    }
    
    func test_interactorPublishTime() {
        sut.connectToVPN()
        
        mockTimer.tick()
        mockTimer.tick()
        mockTimer.tick()
        
        XCTAssertEqual(mockPresenter.counter, 3)
    }
    
    func test_interactorStopPublishingTimeAfterDisconnect() {
        sut.connectToVPN()
        
        mockTimer.tick()
        
        sut.disconnectFromVPN()
        
        mockTimer.tick()
        
        XCTAssertEqual(mockPresenter.counter, 1)
    }
    
    func test_currentLocationSent() {
        let serviceInfo = ServiceInfo(iconName: "bus", title: "bus", ipAdress: "bus", ping: 0)
        mockLocationServes.location = serviceInfo
        
        sut.viewDidAppear()
        
        XCTAssertEqual(mockPresenter.location, serviceInfo)
    }
    
    func test_currentLocationNil() {
        mockLocationServes.location = nil
        
        sut.viewDidAppear()
        
        XCTAssertTrue(mockPresenter.isServerUnavailableSend)
    }
}

private extension HomeInteractorTests {
    
    class MockTimer: TimeService {
        var tick: () -> Void = {}
        private(set) var isStarted = false
        
        func start(interval: TimeInterval, tick: @escaping () -> Void) {
            isStarted = true
            self.tick = tick
        }
        
        func stop() {
            tick = {}
        }
    }
    
    class MockPresenter: HomePresentationLogic {
        var location: ServiceInfo?
        private(set) var isServerUnavailableSend = false
        
        var state: [ConnectionState] = .init()
        private(set) var counter: TimeInterval = 0
        
        func connectionState(_ state: HomeScene.ConnectionState) {
            self.state.append(state)
        }
        
        func connectionTime(_ time: TimeInterval) {
            counter = time
        }
        
        func currentServer(_ serviceInfo: ServiceInfo) {
            location = serviceInfo
        }
        
        func serverUnavailable() {
            isServerUnavailableSend = true
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
            isRequested = true
        }
    }
    
    class MockLocationServes: LocationService {
        var location: ServiceInfo?
        
        func currentLocation() -> ServiceInfo? {
            return location
        }
        
        func basicServices() -> [ServiceInfo] {
            []
        }
        
        func setSelected(_ service: ServiceInfo) {
            
        }
    }
    
    //    func makeSut() -> HomeInteractor {
    //        HomeInteractor(vpnManager: MokVPN(), locationService: MokLocationServes())
    //    }
}
