//
//  TimeService.swift
//  
//
//  Created by Илья Шаповалов on 10.12.2023.
//

import Foundation

public protocol TimeService {
    func start(interval: TimeInterval, tick: @escaping () -> Void)
    func stop()
}

public final class TimeServiceImpl: TimeService {
    public static let shared = TimeServiceImpl()
    
    private var timer: Timer?
    
    private init() {}
    
    public func start(interval: TimeInterval, tick: @escaping () -> Void) {
        timer = Timer(timeInterval: interval, repeats: true) { _ in
            tick()
        }
    }
    
    public func stop() {
        timer?.invalidate()
    }
    
}
