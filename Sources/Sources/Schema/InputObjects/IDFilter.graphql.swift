// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "ID"
public struct IDFilter: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
        __data = data
    }

    public init(
        eq: GraphQLNullable<ID> = nil
    ) {
        __data = InputDict([
            "eq": eq,
        ])
    }

    public var eq: GraphQLNullable<ID> {
        get { __data["eq"] }
        set { __data["eq"] = newValue }
    }
}
