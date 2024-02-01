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
    
    // Тест подключения к VPN
    func test_connectToVPN_ServiceRequested() {
        sut.connectToVPN()
        XCTAssertTrue(mockVPN.isRequested)
        XCTAssertNotNil(mockPresenter.lastPresentedHomeData)
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.connectionState, .connecting)
    }
    
    // Тест успешного подключения к VPN
    func test_connectToVPN_EndWithSuccess() {
        sut.connectToVPN()
        XCTAssertTrue(mockTimer.isStarted)
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.connectionState, "connected")
    }
    
    // Тест ошибки подключения к VPN
    func test_connectToVPN_EndWithError() {
        let error = URLError(.badURL)
        mockVPN.error = error
        sut.connectToVPN()
        XCTAssertFalse(mockTimer.isStarted)
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.connectionState, "error")
    }
    
    // Тест отключения от VPN
    func test_disconnectToVPN() {
        sut.disconnectFromVPN()
        XCTAssertTrue(mockVPN.isRequested)
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.connectionState, "disconnected")
    }
    
    func test_connectToVPN_startsTimer() {
        sut.connectToVPN()
        
        XCTAssertTrue(mockTimer.isStarted)
    }
    
    func test_connectToVPNFailed_doesntStartTimer() {
        mockVPN.error = URLError(.badURL)
        sut.connectToVPN()
        
        XCTAssertFalse(mockTimer.isStarted)
    }
    
    // Тест обновления времени подключения
    func test_interactorPublishTime() {
        sut.connectToVPN()
        mockTimer.tick()
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.connectionTime, "1")
    }
    
    func test_interactorStopPublishingTimeAfterDisconnect() {
        sut.connectToVPN()
        mockTimer.tick()
        
        sut.disconnectFromVPN()
        mockTimer.tick()
        
        let expectedTimeAfterDisconnect = mockPresenter.lastPresentedHomeData?.connectionTime
        XCTAssertEqual(expectedTimeAfterDisconnect, "1")
    }
    
    // Тест обработки текущего местоположения
    func test_currentLocationSent() {
        let serviceInfo = ServiceInfo(iconName: "bus", title: "bus", ipAdress: "bus", ping: 0)
        mockLocationServes.location = serviceInfo
        sut.viewDidAppear()
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.serverInfo?.iconName, "bus")
    }
    
    // Тест обработки отсутствия местоположения
    func test_currentLocationNil() {
        mockLocationServes.location = nil
        sut.viewDidAppear()
        XCTAssertEqual(mockPresenter.lastPresentedHomeData?.connectionState, "disconnected")
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
        
        private(set) var lastPresentedHomeData: HomeViewModel?
        
        func presentHomeData(connectionState: ConnectionState, connectionTime: TimeInterval, serverInfo: ServiceInfo?, error: Error?) {
            let serverViewModel = serverInfo.map { ServerViewModel(from: $0) }
            let errorMessage = error.map { _ in "Error" }
            let viewModel = HomeViewModel(
                connectionState: String(describing: connectionState),
                serverInfo: serverViewModel,
                connectionTime: String(connectionTime),
                errorMessage: errorMessage
            )
            lastPresentedHomeData = viewModel
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
