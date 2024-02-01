//
//  HomePresenterTests.swift
//  
//
//  Created by Владислав on 20.12.2023.
//

import XCTest
import LocationService
import CommonServices
import TimeFormatting
@testable import HomeScene

final class HomePresenterTests: XCTestCase {
    private var sut: HomePresenter!
    private var mockView: MockView!
    private var mockTimeFormatter: MockTimeFormatter!
    
    override func setUp() async throws {
        try await super.setUp()
        let mockLocalizer = MockLocalizer()
        mockTimeFormatter = MockTimeFormatter()
        sut = HomePresenter(timeFormatter: mockTimeFormatter, localizer: mockLocalizer)
        mockView = MockView()
        sut.view = mockView
    }
    
    override func tearDown() async throws {
        sut = nil
        mockView = nil
        try await super.tearDown()
    }
    
    func test_presentHomeData_WithConnectedState() {
        let serviceInfo = ServiceInfo(iconName: "icon", title: "title", ipAdress: "address", ping: 123)
        sut.presentHomeData(connectionState: .connected, connectionTime: 1234, serverInfo: serviceInfo, error: nil)
        
        XCTAssertEqual(mockView.displayedViewModel?.connectionState, "ConnectedKey")
        XCTAssertEqual(mockView.displayedViewModel?.serverInfo?.iconName, "icon")
        XCTAssertEqual(mockView.displayedViewModel?.serverInfo?.title, "title")
        XCTAssertEqual(mockView.displayedViewModel?.serverInfo?.ipAdress, "address")
        XCTAssertEqual(mockView.displayedViewModel?.serverInfo?.ping, "123")
    }
    
    func test_presentHomeData_WithDisconnectedState() {
        sut.presentHomeData(connectionState: .disconnected, connectionTime: 0, serverInfo: nil, error: nil)
        
        XCTAssertEqual(mockView.displayedViewModel?.connectionState, "DisconnectedKey")
        XCTAssertNil(mockView.displayedViewModel?.serverInfo)
    }
    
    func test_presentHomeData_WithLoadingState() {
        sut.presentHomeData(connectionState: .loading, connectionTime: 0, serverInfo: nil, error: nil)
        
        XCTAssertEqual(mockView.displayedViewModel?.connectionState, "ConnectingKey")
    }
    
    func test_presentHomeData_WithErrorState() {
        let error = NSError(domain: "TestError", code: -1, userInfo: nil)
        sut.presentHomeData(connectionState: .error(error), connectionTime: 0, serverInfo: nil, error: error)
        
        let expectedErrorMessage = "ErrorKey: \(error.localizedDescription)"
        XCTAssertEqual(mockView.displayedViewModel?.connectionState, expectedErrorMessage)
    }
    
    func test_presentHomeData_IncludesFormattedConnectionTime() {
        let expectedFormattedTime = "ExpectedFormattedTime"
        mockTimeFormatter.mockedFormattedTime = expectedFormattedTime
        let serviceInfo = ServiceInfo(iconName: "icon", title: "title", ipAdress: "address", ping: 123)
        
        sut.presentHomeData(connectionState: .connected, connectionTime: 1234, serverInfo: serviceInfo, error: nil)

        XCTAssertEqual(mockView.displayedViewModel?.connectionTime, expectedFormattedTime)
    }
}

private extension HomePresenterTests {
    class MockView: HomeDisplayLogic {
        var displayedViewModel: HomeViewModel?
        
        func displayHomeData(_ viewModel: HomeViewModel) {
            displayedViewModel = viewModel
        }
    }
    
    class MockTimeFormatter: TimeFormatting {
        var mockedFormattedTime = "FormattedTime"
        
        func formatTime(_ time: TimeInterval) -> String {
            return mockedFormattedTime
        }
    }
    
    class MockLocalizer: Localizing {
        var disconnected: String = "DisconnectedKey"
        var connecting: String = "ConnectingKey"
        var connected: String = "ConnectedKey"
        var error: String = "ErrorKey"
        var serverUnavailable: String = "ServerErrorKey"
        
        func localizedString(for key: String) -> String {
            return key
        }
    }
}
