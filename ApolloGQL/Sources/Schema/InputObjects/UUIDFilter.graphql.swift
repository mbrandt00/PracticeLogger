// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "UUID"
public struct UUIDFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    eq: GraphQLNullable<UUID> = nil,
    `in`: GraphQLNullable<[UUID]> = nil,
    `is`: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
    neq: GraphQLNullable<UUID> = nil
  ) {
    __data = InputDict([
      "eq": eq,
      "in": `in`,
      "is": `is`,
      "neq": neq
    ])
  }

  public var eq: GraphQLNullable<UUID> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var `in`: GraphQLNullable<[UUID]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
    get { __data["is"] }
    set { __data["is"] = newValue }
  }

  public var neq: GraphQLNullable<UUID> {
    get { __data["neq"] }
    set { __data["neq"] = newValue }
  }
}
