//
//  TimeFormatting.swift
//  
//
//  Created by Владислав on 10.01.2024.
//

import Foundation

public protocol TimeFormatting {
    func formatTime(_ time: TimeInterval) -> String
}

//MARK: - Formatter Time
final class TimeFormatter: TimeFormatting {
    func formatTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: time) ?? "00:00:00"
    }
}
