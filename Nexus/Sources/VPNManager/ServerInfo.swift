//
//  ServerInfo.swift
//  
//
//  Created by Владислав on 10.12.2023.
//

import Foundation

public struct ServerInfo {
    public let userName: String
    public let serverAddress: String
    
    public init(userName: String, serverAddress: String) {
        self.userName = userName
        self.serverAddress = serverAddress
    }
}
