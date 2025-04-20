// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "Datetime"
public struct DatetimeFilter: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
        __data = data
    }

    public init(
        eq: GraphQLNullable<Datetime> = nil,
        gt: GraphQLNullable<Datetime> = nil,
        gte: GraphQLNullable<Datetime> = nil,
        in: GraphQLNullable<[Datetime]> = nil,
        is: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
        lt: GraphQLNullable<Datetime> = nil,
        lte: GraphQLNullable<Datetime> = nil,
        neq: GraphQLNullable<Datetime> = nil
    ) {
        __data = InputDict([
            "eq": eq,
            "gt": gt,
            "gte": gte,
            "in": `in`,
            "is": `is`,
            "lt": lt,
            "lte": lte,
            "neq": neq,
        ])
    }

    public var eq: GraphQLNullable<Datetime> {
        get { __data["eq"] }
        set { __data["eq"] = newValue }
    }

    public var gt: GraphQLNullable<Datetime> {
        get { __data["gt"] }
        set { __data["gt"] = newValue }
    }

    public var gte: GraphQLNullable<Datetime> {
        get { __data["gte"] }
        set { __data["gte"] = newValue }
    }

    public var `in`: GraphQLNullable<[Datetime]> {
        get { __data["in"] }
        set { __data["in"] = newValue }
    }

    public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
        get { __data["is"] }
        set { __data["is"] = newValue }
    }

    public var lt: GraphQLNullable<Datetime> {
        get { __data["lt"] }
        set { __data["lt"] = newValue }
    }

    public var lte: GraphQLNullable<Datetime> {
        get { __data["lte"] }
        set { __data["lte"] = newValue }
    }

    public var neq: GraphQLNullable<Datetime> {
        get { __data["neq"] }
        set { __data["neq"] = newValue }
    }
}
