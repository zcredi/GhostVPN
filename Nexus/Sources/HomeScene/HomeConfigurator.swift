//
//  File.swift
//  
//
//  Created by Владислав on 04.01.2024.
//

import Foundation
import LocationService
import VPNManager
import CommonServices
import TimeFormatting

public protocol HomeConfigurator {
    func configured(_ vc: HomeViewController) -> HomeViewController
}

final class DefaultHomeSceneConfigurator: HomeConfigurator {
    private let vpnManager: VPNManagerProtocol
    private let locationService: LocationService
    private let localizer: Localizing
    private let timeFormatter: TimeFormatting

    init(
        vpnManager: VPNManagerProtocol,
        locationService: LocationService,
        localizer: Localizing,
        timeFormatter: TimeFormatting
    ) {
        self.vpnManager = vpnManager
        self.locationService = locationService
        self.localizer = localizer
        self.timeFormatter = timeFormatter
    }

    func configured(_ vc: HomeViewController) -> HomeViewController {
        let interactor = HomeInteractor(vpnManager: vpnManager, locationService: locationService)
        let presenter = HomePresenter(timeFormatter: timeFormatter, localizer: localizer)
        presenter.view = vc
        interactor.presenter = presenter
        vc.interactor = interactor
        return vc
    }
}
