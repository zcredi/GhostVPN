//
//  VPNManager.swift
//  GhostVPN
//
//  Created by Владислав on 05.12.2023.
//

import NetworkExtension

public protocol VPNManagerProtocol {
    func connectToVPN(_ serverInfo: ServerInfo, completion: @escaping (Error?) -> Void)
    func disconnectFromVPN()
}

final class VPNManager: VPNManagerProtocol {
    private let vpnManager = NEVPNManager.shared()

    func connectToVPN(_ serverInfo: ServerInfo, completion: @escaping (Error?) -> Void) {
        vpnManager.loadFromPreferences { [weak self] error in
            guard let self else { return }
            if let error {
                completion(error)
                return
            }
            
            let vpnProtocol = NEVPNProtocolIKEv2()
            
            // Настроить соединение VPN на основе переданных данных о сервере
            vpnProtocol.username = serverInfo.username
            vpnProtocol.serverAddress = serverInfo.serverAddress
            // Другие настройки, такие как пароль, аутентификация, порты и т. д. могут быть добавлены в соответствии с вашими требованиями
            vpnManager.protocolConfiguration = vpnProtocol
            vpnManager.isEnabled = true

            vpnManager.saveToPreferences { error in
                if let error {
                    completion(error)
                    return
                }

                do {
                    try self.vpnManager.connection.startVPNTunnel()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }

    func disconnectFromVPN() {
        guard vpnManager.connection.status != .disconnected else { return }
        vpnManager.connection.stopVPNTunnel()
    }
}

