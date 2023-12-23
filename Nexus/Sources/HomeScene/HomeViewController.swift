//
//  HomeViewController.swift
//  GhostVPN
//
//  Created by Владислав on 30.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import LocationService
import VPNManager

protocol HomeView: UIView {
    var actionButton: UIButton { get }
    var connectionStateLabel: UILabel { get }
    var iconNameImageView: UIImageView { get }
    var titleServerLabel: UILabel { get }
    var ipAdressLabel: UILabel { get }
    var pingLabel: UILabel { get }
    var timerLabel: UILabel { get }
}

protocol HomeDisplayLogic: AnyObject {
    func displayConnectionState(_ state: String)
    func displayCurrentServer(_ viewModel: ServerViewModel)
    func displayServerError(_ message: String)
    func displayConnectionTime(_ time: String)
}

public final class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    private let vpnManager: VPNManagerProtocol
    private let locationService: LocationService
    
    //MARK: - UI
    
    private let connectionStateLabel = UILabel()
    private let iconNameImageView = UIImageView()
    private let titleServerLabel = UILabel()
    private let ipAdressLabel = UILabel()
    private let pingLabel = UILabel()
    private let timerLabel = UILabel()
    
    
    //MARK: - init(_:)
//    init(
//        view: HomeView,
//        interactor: HomeBusinessLogic
//    ) {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(interactor: HomeBusinessLogic? = nil, vpnManager: VPNManagerProtocol, locationService: LocationService) {
        self.vpnManager = vpnManager
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
        self.interactor = interactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    public override func loadView() {
//        view = Твой Кастомный View
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        setup()
        interactor?.connectToVPN()
        interactor?.disconnectFromVPN()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.viewDidAppear()
    }
    
    // MARK: Setup
    
//    private func setup() {
//        let viewController = self
//        let interactor = HomeInteractor(vpnManager: vpnManager, locationService: locationService)
//        let presenter = HomePresenter(timeFormatter: formatTime)
//        viewController.interactor = interactor
//        interactor.presenter = presenter
//        presenter.view = viewController
//        
//    }
    
    // MARK: View lifecycle
    
    
}

// MARK: HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayConnectionTime(_ time: String) {
        timerLabel.text = time
    }
    
    func displayConnectionState(_ state: String) {
        connectionStateLabel.text = state
    }
    
    func displayCurrentServer(_ viewModel: ServerViewModel) {
        iconNameImageView.image = UIImage(named: viewModel.iconName)
        titleServerLabel.text = viewModel.title
        ipAdressLabel.text = viewModel.ipAdress
        pingLabel.text = String(viewModel.ping)
    }
    
    func displayServerError(_ message: String) {
        showAlert(withTitle: "Ошибка", message: message)
        
        func showAlert(withTitle title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}

private extension HomeViewController {
    func foo() {
        interactor?.connectToVPN()
    }
}
