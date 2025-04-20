// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "String"
public struct StringFilter: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
        __data = data
    }

    public init(
        eq: GraphQLNullable<String> = nil,
        gt: GraphQLNullable<String> = nil,
        gte: GraphQLNullable<String> = nil,
        ilike: GraphQLNullable<String> = nil,
        in: GraphQLNullable<[String]> = nil,
        iregex: GraphQLNullable<String> = nil,
        is: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
        like: GraphQLNullable<String> = nil,
        lt: GraphQLNullable<String> = nil,
        lte: GraphQLNullable<String> = nil,
        neq: GraphQLNullable<String> = nil,
        regex: GraphQLNullable<String> = nil,
        startsWith: GraphQLNullable<String> = nil
    ) {
        __data = InputDict([
            "eq": eq,
            "gt": gt,
            "gte": gte,
            "ilike": ilike,
            "in": `in`,
            "iregex": iregex,
            "is": `is`,
            "like": like,
            "lt": lt,
            "lte": lte,
            "neq": neq,
            "regex": regex,
            "startsWith": startsWith,
        ])
    }

    public var eq: GraphQLNullable<String> {
        get { __data["eq"] }
        set { __data["eq"] = newValue }
    }

    public var gt: GraphQLNullable<String> {
        get { __data["gt"] }
        set { __data["gt"] = newValue }
    }

    public var gte: GraphQLNullable<String> {
        get { __data["gte"] }
        set { __data["gte"] = newValue }
    }

    public var ilike: GraphQLNullable<String> {
        get { __data["ilike"] }
        set { __data["ilike"] = newValue }
    }

    public var `in`: GraphQLNullable<[String]> {
        get { __data["in"] }
        set { __data["in"] = newValue }
    }

    public var iregex: GraphQLNullable<String> {
        get { __data["iregex"] }
        set { __data["iregex"] = newValue }
    }

    public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
        get { __data["is"] }
        set { __data["is"] = newValue }
    }

    public var like: GraphQLNullable<String> {
        get { __data["like"] }
        set { __data["like"] = newValue }
    }

    public var lt: GraphQLNullable<String> {
        get { __data["lt"] }
        set { __data["lt"] = newValue }
    }

    public var lte: GraphQLNullable<String> {
        get { __data["lte"] }
        set { __data["lte"] = newValue }
    }

    public var neq: GraphQLNullable<String> {
        get { __data["neq"] }
        set { __data["neq"] = newValue }
    }

    public var regex: GraphQLNullable<String> {
        get { __data["regex"] }
        set { __data["regex"] = newValue }
    }

    public var startsWith: GraphQLNullable<String> {
        get { __data["startsWith"] }
        set { __data["startsWith"] = newValue }
    }
}
