// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CollectionPiecesWithFallbackFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    pieceId: GraphQLNullable<BigIntFilter> = nil,
    workName: GraphQLNullable<StringFilter> = nil,
    catalogueNumber: GraphQLNullable<IntFilter> = nil,
    userId: GraphQLNullable<UUIDFilter> = nil,
    collectionId: GraphQLNullable<BigIntFilter> = nil,
    composerId: GraphQLNullable<BigIntFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[CollectionPiecesWithFallbackFilter]> = nil,
    or: GraphQLNullable<[CollectionPiecesWithFallbackFilter]> = nil,
    not: GraphQLNullable<CollectionPiecesWithFallbackFilter> = nil
  ) {
    __data = InputDict([
      "pieceId": pieceId,
      "workName": workName,
      "catalogueNumber": catalogueNumber,
      "userId": userId,
      "collectionId": collectionId,
      "composerId": composerId,
      "nodeId": nodeId,
      "and": and,
      "or": or,
      "not": not
    ])
  }

  public var pieceId: GraphQLNullable<BigIntFilter> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var workName: GraphQLNullable<StringFilter> {
    get { __data["workName"] }
    set { __data["workName"] = newValue }
  }

  public var catalogueNumber: GraphQLNullable<IntFilter> {
    get { __data["catalogueNumber"] }
    set { __data["catalogueNumber"] = newValue }
  }

  public var userId: GraphQLNullable<UUIDFilter> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var collectionId: GraphQLNullable<BigIntFilter> {
    get { __data["collectionId"] }
    set { __data["collectionId"] = newValue }
  }

  public var composerId: GraphQLNullable<BigIntFilter> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }

  public var nodeId: GraphQLNullable<IDFilter> {
    get { __data["nodeId"] }
    set { __data["nodeId"] = newValue }
  }

  /// Returns true only if all its inner filters are true, otherwise returns false
  public var and: GraphQLNullable<[CollectionPiecesWithFallbackFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[CollectionPiecesWithFallbackFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<CollectionPiecesWithFallbackFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
