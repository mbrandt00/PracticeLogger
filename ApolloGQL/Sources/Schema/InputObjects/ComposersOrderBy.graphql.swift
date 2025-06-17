// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct ComposersOrderBy: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    firstName: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    lastName: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    nationality: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    musicalEra: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil
  ) {
    __data = InputDict([
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "nationality": nationality,
      "musicalEra": musicalEra,
      "userId": userId
    ])
  }

  public var id: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var firstName: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["firstName"] }
    set { __data["firstName"] = newValue }
  }

  public var lastName: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["lastName"] }
    set { __data["lastName"] = newValue }
  }

  public var nationality: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["nationality"] }
    set { __data["nationality"] = newValue }
  }

  public var musicalEra: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["musicalEra"] }
    set { __data["musicalEra"] = newValue }
  }

  public var userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }
}
