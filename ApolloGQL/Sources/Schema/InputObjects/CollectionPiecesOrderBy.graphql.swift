// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CollectionPiecesOrderBy: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    pieceId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    collectionId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    position: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil
  ) {
    __data = InputDict([
      "id": id,
      "pieceId": pieceId,
      "collectionId": collectionId,
      "position": position
    ])
  }

  public var id: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var pieceId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var collectionId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["collectionId"] }
    set { __data["collectionId"] = newValue }
  }

  public var position: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["position"] }
    set { __data["position"] = newValue }
  }
}
