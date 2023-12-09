//
//  VPNService .swift
//  GhostVPN
//
//  Created by Владислав on 05.12.2023.
//

import NetworkExtension

final class VPNManager {
    private let vpnManager = NEVPNManager.shared()

    func connectToVPN(serverInfo: VPNServerInfo, completion: @escaping (Error?) -> Void) {
        vpnManager.loadFromPreferences { error in
            if let error = error {
                completion(error)
                return
            }
            
            let vpnProtocol = NEVPNProtocolIKEv2()
            
            // Настроить соединение VPN на основе переданных данных о сервере
            vpnProtocol.username = "yourUsername"
            vpnProtocol.serverAddress = serverInfo.ip
            // Другие настройки, такие как пароль, аутентификация, порты и т. д. могут быть добавлены в соответствии с вашими требованиями
            self.vpnManager.protocolConfiguration = vpnProtocol
            self.vpnManager.isEnabled = true

            self.vpnManager.saveToPreferences { error in
                if let error = error {
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

    func disconnectFromVPN(completion: @escaping (Error?) -> Void) {
        if vpnManager.connection.status != .disconnected {
            vpnManager.connection.stopVPNTunnel()
        }
        completion(nil)
    }
}

