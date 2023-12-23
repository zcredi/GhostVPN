//
//  HomePresenterTests.swift
//  
//
//  Created by Владислав on 20.12.2023.
//

import XCTest
import LocationService
@testable import HomeScene

final class HomePresenterTests: XCTestCase {
    private var sut: HomePresenter!
    private var mockView: MockView!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = HomePresenter()
        mockView = MockView()
        sut.view = mockView
    }
    
    override func tearDown() async throws {
        sut = nil
        mockView = nil
        try await super.tearDown()
    }
    
    func test_connectionState_isDisplayed() {
        sut.connectionState(.connected)
        
        XCTAssertEqual(mockView.displayedConnectionState, "Connected")
    }
    
    func test_connectionState_whenDisconnected() {
        sut.connectionState(.disconnected)
        
        XCTAssertEqual(mockView.displayedConnectionState, "Disconnected")
    }
    
    func test_connectionState_whenLoading() {
        sut.connectionState(.loading)
        
        XCTAssertEqual(mockView.displayedConnectionState, "Connecting")
    }
    
    func test_connectionState_whenError() {
        let error = URLError(.badURL)
        sut.connectionState(.error(error))
        
        let errorMessage = "Error: \(error.localizedDescription)"
        XCTAssertEqual(mockView.displayedConnectionState, errorMessage)
    }
    
    func test_currentServer_isDisplayed() {
        let serviceInfo = ServiceInfo(iconName: "bus", title: "bus", ipAdress: "bus", ping: 0)
        sut.currentServer(serviceInfo)
        
        guard let viewModel = mockView.displayedServerViewModel else {
            XCTFail("ServerViewModel не был передан.")
            return
        }
        
        XCTAssertEqual(viewModel.iconName, serviceInfo.iconName)
        XCTAssertEqual(viewModel.title, serviceInfo.title)
        XCTAssertEqual(viewModel.ipAdress, serviceInfo.ipAdress)
        XCTAssertEqual(viewModel.ping, serviceInfo.ping)
    }
    
    func test_serverUnavailable_isCalledWithErrorMessage() {
        sut.serverUnavailable()
        
        XCTAssertEqual(mockView.displayedErrorMessage, "Сервер недоступен.")
    }
    
    func test_displayConnectionTime() {
        let timeInterval: TimeInterval = 123
        sut.connectionTime(timeInterval)
        
        XCTAssertEqual(mockView.displayedConnectionTime, "00:02:03")
    }
}

private extension HomePresenterTests {
    class MockView: HomeDisplayLogic {
        var displayedConnectionState: String?
        var displayedServerViewModel: ServerViewModel?
        var displayedErrorMessage: String?
        var displayedConnectionTime: String?
        
        func displayConnectionState(_ state: String) {
            displayedConnectionState = state
        }
        
        func displayCurrentServer(_ viewModel: ServerViewModel) {
            displayedServerViewModel = viewModel
        }
        
        func displayServerError(_ message: String) {
            displayedErrorMessage = message
        }
        
        func displayConnectionTime(_ time: String) {
            displayedConnectionTime = time
        }
    }
}
