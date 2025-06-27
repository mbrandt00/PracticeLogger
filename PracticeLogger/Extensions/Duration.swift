//
//  Duration.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/25/25.
//

extension Duration {
    var shortFormatted: String {
        let totalSeconds = Int(self.components.seconds)
        let days = totalSeconds / 86400 // 24 * 60 * 60
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if days > 0 {
            if hours > 0 {
                return "\(days)d \(hours)h"
            } else if minutes > 0 {
                return "\(days)d \(minutes)m"
            } else {
                return "\(days)d"
            }
        } else if hours > 0 {
            if minutes > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(hours)h"
            }
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }

    var mediumFormatted: String {
        let totalSeconds = Int(self.components.seconds)
        let days = totalSeconds / 86400
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if days > 0 {
            if hours > 0 {
                return "\(days) day\(days != 1 ? "s" : "") \(hours) hour\(hours != 1 ? "s" : "")"
            } else if minutes > 0 {
                return "\(days) day\(days != 1 ? "s" : "") \(minutes) minute\(minutes != 1 ? "s" : "")"
            } else {
                return "\(days) day\(days != 1 ? "s" : "")"
            }
        } else if hours > 0 {
            if minutes > 0 {
                return "\(hours) hour\(hours != 1 ? "s" : "") \(minutes) minute\(minutes != 1 ? "s" : "")"
            } else {
                return "\(hours) hour\(hours != 1 ? "s" : "")"
            }
        } else if minutes > 0 {
            return "\(minutes) minute\(minutes != 1 ? "s" : "")"
        } else {
            return "\(seconds) second\(seconds != 1 ? "s" : "")"
        }
    }
}
