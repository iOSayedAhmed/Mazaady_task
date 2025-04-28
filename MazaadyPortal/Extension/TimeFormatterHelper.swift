//
//  TimeFormatterHelper.swift
//  MazaadyPortal
//
//  Created by iOSAYed on 26/04/2025.
//

import Foundation

final class TimeFormatterHelper {
    static func extractTimeComponents(from seconds: Double) -> (days: Int, hours: Int, minutes: Int) {
        let totalSeconds = Int(seconds)
        let days = totalSeconds / 86400
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60
        return (days, hours, minutes)
    }
}
