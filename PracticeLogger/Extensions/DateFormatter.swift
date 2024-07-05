//
//  DateFormatter.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/4/24.
//

import Foundation

extension DateFormatter {

    /// Essentially iso8601WithoutFractionalSeconds,  suapbase realtime returns this data type
    static let supabaseIso: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
