// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "Int"
public struct IntFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    eq: GraphQLNullable<Int> = nil,
    gt: GraphQLNullable<Int> = nil,
    gte: GraphQLNullable<Int> = nil,
    `in`: GraphQLNullable<[Int]> = nil,
    `is`: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
    lt: GraphQLNullable<Int> = nil,
    lte: GraphQLNullable<Int> = nil,
    neq: GraphQLNullable<Int> = nil
  ) {
    __data = InputDict([
      "eq": eq,
      "gt": gt,
      "gte": gte,
      "in": `in`,
      "is": `is`,
      "lt": lt,
      "lte": lte,
      "neq": neq
    ])
  }

  public var eq: GraphQLNullable<Int> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var gt: GraphQLNullable<Int> {
    get { __data["gt"] }
    set { __data["gt"] = newValue }
  }

  public var gte: GraphQLNullable<Int> {
    get { __data["gte"] }
    set { __data["gte"] = newValue }
  }

  public var `in`: GraphQLNullable<[Int]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
    get { __data["is"] }
    set { __data["is"] = newValue }
  }

  public var lt: GraphQLNullable<Int> {
    get { __data["lt"] }
    set { __data["lt"] = newValue }
  }

  public var lte: GraphQLNullable<Int> {
    get { __data["lte"] }
    set { __data["lte"] = newValue }
  }

  public var neq: GraphQLNullable<Int> {
    get { __data["neq"] }
    set { __data["neq"] = newValue }
  }
}
