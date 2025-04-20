// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "BigInt"
public struct BigIntFilter: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
        __data = data
    }

    public init(
        eq: GraphQLNullable<BigInt> = nil,
        gt: GraphQLNullable<BigInt> = nil,
        gte: GraphQLNullable<BigInt> = nil,
        in: GraphQLNullable<[BigInt]> = nil,
        is: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
        lt: GraphQLNullable<BigInt> = nil,
        lte: GraphQLNullable<BigInt> = nil,
        neq: GraphQLNullable<BigInt> = nil
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

    public var eq: GraphQLNullable<BigInt> {
        get { __data["eq"] }
        set { __data["eq"] = newValue }
    }

    public var gt: GraphQLNullable<BigInt> {
        get { __data["gt"] }
        set { __data["gt"] = newValue }
    }

    public var gte: GraphQLNullable<BigInt> {
        get { __data["gte"] }
        set { __data["gte"] = newValue }
    }

    public var `in`: GraphQLNullable<[BigInt]> {
        get { __data["in"] }
        set { __data["in"] = newValue }
    }

    public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
        get { __data["is"] }
        set { __data["is"] = newValue }
    }

    public var lt: GraphQLNullable<BigInt> {
        get { __data["lt"] }
        set { __data["lt"] = newValue }
    }

    public var lte: GraphQLNullable<BigInt> {
        get { __data["lte"] }
        set { __data["lte"] = newValue }
    }

    public var neq: GraphQLNullable<BigInt> {
        get { __data["neq"] }
        set { __data["neq"] = newValue }
    }
}
