//
//  VPNModel.swift
//  GhostVPN
//
//  Created by Владислав on 05.12.2023.
//

import Foundation

// MARK: - NetworkError

enum NetworkError: Error {
    case invalidURL
    case noData
}

// MARK: - VPNServerInfo
struct VPNServerInfo: Codable {
    let ip: String
    let security: Security
    let location: Location
    let network: Network
}

// MARK: - Location
struct Location: Codable {
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
struct Network: Codable {
    let network, autonomousSystemNumber, autonomousSystemOrganization: String

    enum CodingKeys: String, CodingKey {
        case network
        case autonomousSystemNumber = "autonomous_system_number"
        case autonomousSystemOrganization = "autonomous_system_organization"
    }
}

// MARK: - Security
struct Security: Codable {
    let vpn, proxy, tor, relay: Bool
}
