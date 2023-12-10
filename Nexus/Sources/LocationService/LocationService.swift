//
//  LocationService.swift
//
//
//  Created by Илья Шаповалов on 09.12.2023.
//

import Foundation

public struct ServiceInfo {
    public let iconName: String
    public let title: String
    public let ipAddress: String
    public let ping: Int
    
    public init(iconName: String, title: String, ipAddress: String, ping: Int) {
        self.iconName = iconName
        self.title = title
        self.ipAddress = ipAddress
        self.ping = ping
    }
}

public protocol LocationService {
    func currentLocation() -> ServiceInfo
    func basicServices() -> [ServiceInfo]
    func setSelected(_ service: ServiceInfo)
}
