//
//  VPNServerInfo.swift
//  GhostVPN
//
//  Created by Владислав on 05.12.2023.
//

import Foundation

// MARK: - VPNServerInfo
 public struct VPNServerInfo: Codable {
    public let ip: String
    public let security: Security
    public let location: Location
    public let network: Network
}

// MARK: - Location
public struct Location: Codable {
    let city, region, country, continent: String
    let regionCode, countryCode, continentCode, latitude: String
    let longitude, timeZone, localeCode, metroCode: String
    let isInEuropeanUnion: Bool
    
    enum CodingKeys: String, CodingKey {
        case city, region, country, continent
        case regionCode = "region_code"
        case countryCode = "country_code"
        case continentCode = "continent_code"
        case latitude, longitude
        case timeZone = "time_zone"
        case localeCode = "locale_code"
        case metroCode = "metro_code"
        case isInEuropeanUnion = "is_in_european_union"
    }
}

// MARK: - Network
public struct Network: Codable {
    let network, autonomousSystemNumber, autonomousSystemOrganization: String
    
    enum CodingKeys: String, CodingKey {
        case network
        case autonomousSystemNumber = "autonomous_system_number"
        case autonomousSystemOrganization = "autonomous_system_organization"
    }
}

// MARK: - Security
public  struct Security: Codable {
    let vpn, proxy, tor, relay: Bool
}
