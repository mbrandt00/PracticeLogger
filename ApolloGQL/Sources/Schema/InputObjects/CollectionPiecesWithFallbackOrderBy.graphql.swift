// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CollectionPiecesWithFallbackOrderBy: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    pieceId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    workName: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    catalogueNumber: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    collectionId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    composerId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil
  ) {
    __data = InputDict([
      "pieceId": pieceId,
      "workName": workName,
      "catalogueNumber": catalogueNumber,
      "userId": userId,
      "collectionId": collectionId,
      "composerId": composerId
    ])
  }

  public var pieceId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var workName: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["workName"] }
    set { __data["workName"] = newValue }
  }

  public var catalogueNumber: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["catalogueNumber"] }
    set { __data["catalogueNumber"] = newValue }
  }

  public var userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var collectionId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["collectionId"] }
    set { __data["collectionId"] = newValue }
  }

  public var composerId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }
}
