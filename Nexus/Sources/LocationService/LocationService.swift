//
//  LocationService.swift
//  
//
//  Created by Владислав on 11.12.2023.
//

import Foundation

public struct ServiceInfo: Equatable {
    public let iconName: String
    public let title: String
    public let ipAdress: String
    public let ping: Int
    
    public init(iconName: String, title: String, ipAdress: String, ping: Int) {
        self.iconName = iconName
        self.title = title
        self.ipAdress = ipAdress
        self.ping = ping
    }
}

public protocol LocationService {
    func currentLocation() -> ServiceInfo?
    func basicServices() -> [ServiceInfo]
    func setSelected(_ service: ServiceInfo)
}
