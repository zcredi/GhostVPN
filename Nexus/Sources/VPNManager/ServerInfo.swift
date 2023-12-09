//
//  ServerInfo.swift
//
//
//  Created by Илья Шаповалов on 09.12.2023.
//

import Foundation

public struct ServerInfo {
    public let username: String
    public let serverAddress: String
    
    public init(username: String, serverAddress: String) {
        self.username = username
        self.serverAddress = serverAddress
    }
}
