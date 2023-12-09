//
//  ServerInfoDownloader.swift
//  
//
//  Created by Илья Шаповалов on 09.12.2023.
//

import Foundation

public struct ServerInfoDownloader {
    //MARK: - Pubic properties
    private let session: URLSession
    private let decoder: JSONDecoder
    
    //MARK: - init(_:)
    public init(
        apiKey: String,
        timeout: TimeInterval = 10,
        keyDecoding: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecoding
    }
    
    //MARK: - Public methods
    public func get(
        _ request: URLRequest,
        completionHandler: @escaping (Result<VPNServerInfo, Error>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data else {
                return
            }
            
            do {
                let info = try decoder.decode(VPNServerInfo.self, from: data)
                completionHandler(.success(info))
            } catch {
                completionHandler(.failure(error))
            }
            return
        }
        task.resume()
    }
}
