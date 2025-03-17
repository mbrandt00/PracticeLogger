// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PieceFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<BigIntFilter> = nil,
    workName: GraphQLNullable<StringFilter> = nil,
    composerId: GraphQLNullable<BigIntFilter> = nil,
    nickname: GraphQLNullable<StringFilter> = nil,
    userId: GraphQLNullable<UUIDFilter> = nil,
    format: GraphQLNullable<PieceFormatFilter> = nil,
    keySignature: GraphQLNullable<KeySignatureTypeFilter> = nil,
    catalogueType: GraphQLNullable<CatalogueTypeFilter> = nil,
    catalogueNumber: GraphQLNullable<IntFilter> = nil,
    updatedAt: GraphQLNullable<DatetimeFilter> = nil,
    createdAt: GraphQLNullable<DatetimeFilter> = nil,
    searchableText: GraphQLNullable<StringFilter> = nil,
    catalogueTypeNumDesc: GraphQLNullable<StringFilter> = nil,
    catalogueNumberSecondary: GraphQLNullable<IntFilter> = nil,
    compositionYear: GraphQLNullable<IntFilter> = nil,
    compositionYearDesc: GraphQLNullable<StringFilter> = nil,
    pieceStyle: GraphQLNullable<StringFilter> = nil,
    wikipediaUrl: GraphQLNullable<StringFilter> = nil,
    instrumentation: GraphQLNullable<StringListFilter> = nil,
    compositionYearString: GraphQLNullable<StringFilter> = nil,
    subPieceType: GraphQLNullable<StringFilter> = nil,
    subPieceCount: GraphQLNullable<IntFilter> = nil,
    imslpUrl: GraphQLNullable<StringFilter> = nil,
    imslpPieceId: GraphQLNullable<BigIntFilter> = nil,
    totalPracticeTime: GraphQLNullable<IntFilter> = nil,
    lastPracticed: GraphQLNullable<DatetimeFilter> = nil,
    isImslp: GraphQLNullable<BooleanFilter> = nil,
    collectionId: GraphQLNullable<BigIntFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[PieceFilter]> = nil,
    or: GraphQLNullable<[PieceFilter]> = nil,
    not: GraphQLNullable<PieceFilter> = nil
  ) {
    __data = InputDict([
      "id": id,
      "workName": workName,
      "composerId": composerId,
      "nickname": nickname,
      "userId": userId,
      "format": format,
      "keySignature": keySignature,
      "catalogueType": catalogueType,
      "catalogueNumber": catalogueNumber,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
      "searchableText": searchableText,
      "catalogueTypeNumDesc": catalogueTypeNumDesc,
      "catalogueNumberSecondary": catalogueNumberSecondary,
      "compositionYear": compositionYear,
      "compositionYearDesc": compositionYearDesc,
      "pieceStyle": pieceStyle,
      "wikipediaUrl": wikipediaUrl,
      "instrumentation": instrumentation,
      "compositionYearString": compositionYearString,
      "subPieceType": subPieceType,
      "subPieceCount": subPieceCount,
      "imslpUrl": imslpUrl,
      "imslpPieceId": imslpPieceId,
      "totalPracticeTime": totalPracticeTime,
      "lastPracticed": lastPracticed,
      "isImslp": isImslp,
      "collectionId": collectionId,
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

  public var nickname: GraphQLNullable<StringFilter> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
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

  public var searchableText: GraphQLNullable<StringFilter> {
    get { __data["searchableText"] }
    set { __data["searchableText"] = newValue }
  }

  public var catalogueTypeNumDesc: GraphQLNullable<StringFilter> {
    get { __data["catalogueTypeNumDesc"] }
    set { __data["catalogueTypeNumDesc"] = newValue }
  }

  public var catalogueNumberSecondary: GraphQLNullable<IntFilter> {
    get { __data["catalogueNumberSecondary"] }
    set { __data["catalogueNumberSecondary"] = newValue }
  }

  public var compositionYear: GraphQLNullable<IntFilter> {
    get { __data["compositionYear"] }
    set { __data["compositionYear"] = newValue }
  }

  public var compositionYearDesc: GraphQLNullable<StringFilter> {
    get { __data["compositionYearDesc"] }
    set { __data["compositionYearDesc"] = newValue }
  }

  public var pieceStyle: GraphQLNullable<StringFilter> {
    get { __data["pieceStyle"] }
    set { __data["pieceStyle"] = newValue }
  }

  public var wikipediaUrl: GraphQLNullable<StringFilter> {
    get { __data["wikipediaUrl"] }
    set { __data["wikipediaUrl"] = newValue }
  }

  public var instrumentation: GraphQLNullable<StringListFilter> {
    get { __data["instrumentation"] }
    set { __data["instrumentation"] = newValue }
  }

  public var compositionYearString: GraphQLNullable<StringFilter> {
    get { __data["compositionYearString"] }
    set { __data["compositionYearString"] = newValue }
  }

  public var subPieceType: GraphQLNullable<StringFilter> {
    get { __data["subPieceType"] }
    set { __data["subPieceType"] = newValue }
  }

  public var subPieceCount: GraphQLNullable<IntFilter> {
    get { __data["subPieceCount"] }
    set { __data["subPieceCount"] = newValue }
  }

  public var imslpUrl: GraphQLNullable<StringFilter> {
    get { __data["imslpUrl"] }
    set { __data["imslpUrl"] = newValue }
  }

  public var imslpPieceId: GraphQLNullable<BigIntFilter> {
    get { __data["imslpPieceId"] }
    set { __data["imslpPieceId"] = newValue }
  }

  public var totalPracticeTime: GraphQLNullable<IntFilter> {
    get { __data["totalPracticeTime"] }
    set { __data["totalPracticeTime"] = newValue }
  }

  public var lastPracticed: GraphQLNullable<DatetimeFilter> {
    get { __data["lastPracticed"] }
    set { __data["lastPracticed"] = newValue }
  }

  public var isImslp: GraphQLNullable<BooleanFilter> {
    get { __data["isImslp"] }
    set { __data["isImslp"] = newValue }
  }

  public var collectionId: GraphQLNullable<BigIntFilter> {
    get { __data["collectionId"] }
    set { __data["collectionId"] = newValue }
  }

  public var nodeId: GraphQLNullable<IDFilter> {
    get { __data["nodeId"] }
    set { __data["nodeId"] = newValue }
  }

  /// Returns true only if all its inner filters are true, otherwise returns false
  public var and: GraphQLNullable<[PieceFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[PieceFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<PieceFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
