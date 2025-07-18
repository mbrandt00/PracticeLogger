// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "Boolean"
public struct BooleanFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    eq: GraphQLNullable<Bool> = nil,
    `is`: GraphQLNullable<GraphQLEnum<FilterIs>> = nil
  ) {
    __data = InputDict([
      "eq": eq,
      "is": `is`
    ])
  }

  public var eq: GraphQLNullable<Bool> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
    get { __data["is"] }
    set { __data["is"] = newValue }
  }
}
