// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Boolean expression comparing fields on type "KeySignatureType"
public struct KeySignatureTypeFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    eq: GraphQLNullable<GraphQLEnum<KeySignatureType>> = nil,
    `in`: GraphQLNullable<[GraphQLEnum<KeySignatureType>]> = nil,
    `is`: GraphQLNullable<GraphQLEnum<FilterIs>> = nil,
    neq: GraphQLNullable<GraphQLEnum<KeySignatureType>> = nil
  ) {
    __data = InputDict([
      "eq": eq,
      "in": `in`,
      "is": `is`,
      "neq": neq
    ])
  }

  public var eq: GraphQLNullable<GraphQLEnum<KeySignatureType>> {
    get { __data["eq"] }
    set { __data["eq"] = newValue }
  }

  public var `in`: GraphQLNullable<[GraphQLEnum<KeySignatureType>]> {
    get { __data["in"] }
    set { __data["in"] = newValue }
  }

  public var `is`: GraphQLNullable<GraphQLEnum<FilterIs>> {
    get { __data["is"] }
    set { __data["is"] = newValue }
  }

  public var neq: GraphQLNullable<GraphQLEnum<KeySignatureType>> {
    get { __data["neq"] }
    set { __data["neq"] = newValue }
  }
}
