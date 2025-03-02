// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.
import ApolloAPI
import Foundation

public typealias Datetime = Foundation.Date

extension Foundation.Date: CustomScalarType {
    private static let formatters: [DateFormatter] = {
        // Create an array of formatters to try in sequence
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ssZ", // With timezone (like 2025-03-02T04:13:06+00:00)
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ", // With milliseconds and timezone
            "yyyy-MM-dd'T'HH:mm:ss", // Without timezone (like 2025-03-02T04:13:06)
            "yyyy-MM-dd'T'HH:mm:ss.SSS" // With milliseconds, without timezone
        ]

        return formats.map { format in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }
    }()

    private static let encodingFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    public init(_jsonValue value: JSONValue) throws {
        guard let string = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
        }

        // Try all formatters until one works
        for formatter in Self.formatters {
            if let date = formatter.date(from: string) {
                self = date
                return
            }
        }

        // If we get here, none of the formatters worked
        throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
    }

    public var _jsonValue: JSONValue {
        return Self.encodingFormatter.string(from: self)
    }
}
