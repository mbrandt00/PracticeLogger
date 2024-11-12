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
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    public init(_jsonValue value: JSONValue) throws {
        guard let string = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
        }

        // Parse the date string using the custom DateFormatter
        guard let date = Self.dateFormatter.date(from: string) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }

        self = date
    }

    public var _jsonValue: JSONValue {
        return Self.dateFormatter.string(from: self)
    }
}
