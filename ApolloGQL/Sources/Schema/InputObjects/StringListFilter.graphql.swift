// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "StringList"
public struct StringListFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    containedBy: GraphQLNullable<[String]> = nil,
    contains: GraphQLNullable<[String]> = nil,
    eq: GraphQLNullable<[String]> = nil,
    `is`: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
    overlaps: GraphQLNullable<[String]> = nil
  ) {
    __data = InputDict([
      "containedBy": containedBy,
      "contains": contains,
      "eq": eq,
      "is": `is`,
      "overlaps": overlaps
    ])
  }

  public var containedBy: GraphQLNullable<[String]> {
    get { __data["containedBy"] }
    set { __data["containedBy"] = newValue }
  }

  public var contains: GraphQLNullable<[String]> {
    get { __data["contains"] }
    set { __data["contains"] = newValue }
  }

  public var eq: GraphQLNullable<[String]> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
    get { __data["is"] }
    set { __data["is"] = newValue }
  }

  public var overlaps: GraphQLNullable<[String]> {
    get { __data["overlaps"] }
    set { __data["overlaps"] = newValue }
  }
}
