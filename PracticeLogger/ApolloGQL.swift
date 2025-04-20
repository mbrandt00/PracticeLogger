//
//  ApolloGQL.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/1/25.
//

import ApolloGQL
import Foundation

extension ApolloGQL.Datetime: ScalarType {
    // If Datetime already has an initializer that takes a Date, use it
    public static func decode(from decoder: Decoder) throws -> ApolloGQL.Datetime {
        let container = try decoder.singleValueContainer()

        let stringValue = try? container.decode(String.self)
        let date = stringValue.flatMap { DateFormatter.iso8601Full.date(from: $0) }

        if let date {
            return ApolloGQL.Datetime(_jsonValue: date)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode ApolloGQL.Datetime"
            )
        }
    }
}
