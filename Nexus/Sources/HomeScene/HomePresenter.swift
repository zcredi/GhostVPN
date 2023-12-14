//
//  HomePresenter.swift
//  GhostVPN
//
//  Created by Владислав on 30.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation

enum ConnectionState: Equatable {
    case disconnected
    case loading
    case connected
    case error(Error)
    
    static func == (lhs: ConnectionState, rhs: ConnectionState) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

protocol HomePresentationLogic: AnyObject {
    func  connectionState(_ state: ConnectionState)
    func connectionTime(_ time: TimeInterval)
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func connectionState(_ state: ConnectionState) {
        
    }
    
    func connectionTime(_ time: TimeInterval) {
        
    }
    
}
