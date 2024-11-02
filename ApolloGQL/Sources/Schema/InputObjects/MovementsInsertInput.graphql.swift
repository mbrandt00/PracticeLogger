// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct MovementsInsertInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    pieceId: GraphQLNullable<UUID> = nil,
    name: GraphQLNullable<String> = nil,
    number: GraphQLNullable<Int> = nil
  ) {
    __data = InputDict([
      "pieceId": pieceId,
      "name": name,
      "number": number
    ])
  }

  public var pieceId: GraphQLNullable<UUID> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var number: GraphQLNullable<Int> {
    get { __data["number"] }
    set { __data["number"] = newValue }
  }
}
