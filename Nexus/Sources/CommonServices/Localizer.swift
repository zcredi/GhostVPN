//
//  File.swift
//  
//
//  Created by Владислав on 06.01.2024.
//

import Foundation

public protocol Localizing {
    var disconnected: String { get }
    var connecting: String { get }
    var connected: String { get }
    var error: String { get }
    var serverUnavailable: String { get }
    
    func localizedString(for key: String) -> String
}

    var disconnected: String {
        return localizedString(for: "DisconnectedKey")
    }
    
    var connecting: String {
        return localizedString(for: "ConnectingKey")
    }
    
    var connected: String {
        return localizedString(for: "ConnectedKey")
    }
    
    var error: String {
        return localizedString(for: "ErrorKey")
    }
    
    var serverUnavailable: String {
        return localizedString(for: "ServerErrorKey")
    }
    
    func localizedString(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
