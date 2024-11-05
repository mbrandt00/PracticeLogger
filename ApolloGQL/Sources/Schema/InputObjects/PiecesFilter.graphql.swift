// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PiecesFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<BigIntFilter> = nil,
    workName: GraphQLNullable<StringFilter> = nil,
    composerId: GraphQLNullable<BigIntFilter> = nil,
    userId: GraphQLNullable<UUIDFilter> = nil,
    format: GraphQLNullable<PieceFormatFilter> = nil,
    keySignature: GraphQLNullable<KeySignatureTypeFilter> = nil,
    tonality: GraphQLNullable<KeySignatureTonalityFilter> = nil,
    catalogueType: GraphQLNullable<CatalogueTypeFilter> = nil,
    catalogueNumber: GraphQLNullable<IntFilter> = nil,
    updatedAt: GraphQLNullable<DatetimeFilter> = nil,
    createdAt: GraphQLNullable<DatetimeFilter> = nil,
    nickname: GraphQLNullable<StringFilter> = nil,
    fts: GraphQLNullable<OpaqueFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[PiecesFilter]> = nil,
    or: GraphQLNullable<[PiecesFilter]> = nil,
    not: GraphQLNullable<PiecesFilter> = nil
  ) {
    __data = InputDict([
      "id": id,
      "workName": workName,
      "composerId": composerId,
      "userId": userId,
      "format": format,
      "keySignature": keySignature,
      "tonality": tonality,
      "catalogueType": catalogueType,
      "catalogueNumber": catalogueNumber,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
      "nickname": nickname,
      "fts": fts,
      "nodeId": nodeId,
      "and": and,
      "or": or,
      "not": not
    ])
  }

  public var id: GraphQLNullable<BigIntFilter> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var workName: GraphQLNullable<StringFilter> {
    get { __data["workName"] }
    set { __data["workName"] = newValue }
  }

  public var composerId: GraphQLNullable<BigIntFilter> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }

  public var userId: GraphQLNullable<UUIDFilter> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var format: GraphQLNullable<PieceFormatFilter> {
    get { __data["format"] }
    set { __data["format"] = newValue }
  }

  public var keySignature: GraphQLNullable<KeySignatureTypeFilter> {
    get { __data["keySignature"] }
    set { __data["keySignature"] = newValue }
  }

  public var tonality: GraphQLNullable<KeySignatureTonalityFilter> {
    get { __data["tonality"] }
    set { __data["tonality"] = newValue }
  }

  public var catalogueType: GraphQLNullable<CatalogueTypeFilter> {
    get { __data["catalogueType"] }
    set { __data["catalogueType"] = newValue }
  }

  public var catalogueNumber: GraphQLNullable<IntFilter> {
    get { __data["catalogueNumber"] }
    set { __data["catalogueNumber"] = newValue }
  }

  public var updatedAt: GraphQLNullable<DatetimeFilter> {
    get { __data["updatedAt"] }
    set { __data["updatedAt"] = newValue }
  }

  public var createdAt: GraphQLNullable<DatetimeFilter> {
    get { __data["createdAt"] }
    set { __data["createdAt"] = newValue }
  }

  public var nickname: GraphQLNullable<StringFilter> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
  }

  public var fts: GraphQLNullable<OpaqueFilter> {
    get { __data["fts"] }
    set { __data["fts"] = newValue }
  }

  public var nodeId: GraphQLNullable<IDFilter> {
    get { __data["nodeId"] }
    set { __data["nodeId"] = newValue }
  }

  /// Returns true only if all its inner filters are true, otherwise returns false
  public var and: GraphQLNullable<[PiecesFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[PiecesFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<PiecesFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
