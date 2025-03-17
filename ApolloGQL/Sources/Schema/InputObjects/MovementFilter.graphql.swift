// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct MovementFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<BigIntFilter> = nil,
    pieceId: GraphQLNullable<BigIntFilter> = nil,
    name: GraphQLNullable<StringFilter> = nil,
    number: GraphQLNullable<IntFilter> = nil,
    keySignature: GraphQLNullable<KeySignatureTypeFilter> = nil,
    nickname: GraphQLNullable<StringFilter> = nil,
    downloadUrl: GraphQLNullable<StringFilter> = nil,
    totalPracticeTime: GraphQLNullable<IntFilter> = nil,
    lastPracticed: GraphQLNullable<DatetimeFilter> = nil,
    imslpPieceId: GraphQLNullable<BigIntFilter> = nil,
    imslpMovementId: GraphQLNullable<BigIntFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[MovementFilter]> = nil,
    or: GraphQLNullable<[MovementFilter]> = nil,
    not: GraphQLNullable<MovementFilter> = nil
  ) {
    __data = InputDict([
      "id": id,
      "pieceId": pieceId,
      "name": name,
      "number": number,
      "keySignature": keySignature,
      "nickname": nickname,
      "downloadUrl": downloadUrl,
      "totalPracticeTime": totalPracticeTime,
      "lastPracticed": lastPracticed,
      "imslpPieceId": imslpPieceId,
      "imslpMovementId": imslpMovementId,
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

  public var pieceId: GraphQLNullable<BigIntFilter> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var name: GraphQLNullable<StringFilter> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var number: GraphQLNullable<IntFilter> {
    get { __data["number"] }
    set { __data["number"] = newValue }
  }

  public var keySignature: GraphQLNullable<KeySignatureTypeFilter> {
    get { __data["keySignature"] }
    set { __data["keySignature"] = newValue }
  }

  public var nickname: GraphQLNullable<StringFilter> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
  }

  public var downloadUrl: GraphQLNullable<StringFilter> {
    get { __data["downloadUrl"] }
    set { __data["downloadUrl"] = newValue }
  }

  public var totalPracticeTime: GraphQLNullable<IntFilter> {
    get { __data["totalPracticeTime"] }
    set { __data["totalPracticeTime"] = newValue }
  }

  public var lastPracticed: GraphQLNullable<DatetimeFilter> {
    get { __data["lastPracticed"] }
    set { __data["lastPracticed"] = newValue }
  }

  public var imslpPieceId: GraphQLNullable<BigIntFilter> {
    get { __data["imslpPieceId"] }
    set { __data["imslpPieceId"] = newValue }
  }

  public var imslpMovementId: GraphQLNullable<BigIntFilter> {
    get { __data["imslpMovementId"] }
    set { __data["imslpMovementId"] = newValue }
  }

  public var nodeId: GraphQLNullable<IDFilter> {
    get { __data["nodeId"] }
    set { __data["nodeId"] = newValue }
  }

  /// Returns true only if all its inner filters are true, otherwise returns false
  public var and: GraphQLNullable<[MovementFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[MovementFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<MovementFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
