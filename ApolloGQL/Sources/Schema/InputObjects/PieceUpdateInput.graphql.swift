// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PieceUpdateInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    workName: GraphQLNullable<String> = nil,
    composerId: GraphQLNullable<BigInt> = nil,
    nickname: GraphQLNullable<String> = nil,
    userId: GraphQLNullable<UUID> = nil,
    format: GraphQLNullable<GraphQLEnum<PieceFormat>> = nil,
    keySignature: GraphQLNullable<GraphQLEnum<KeySignatureType>> = nil,
    catalogueType: GraphQLNullable<GraphQLEnum<CatalogueType>> = nil,
    catalogueNumber: GraphQLNullable<Int> = nil,
    updatedAt: GraphQLNullable<Datetime> = nil,
    createdAt: GraphQLNullable<Datetime> = nil,
    searchableText: GraphQLNullable<String> = nil,
    catalogueTypeNumDesc: GraphQLNullable<String> = nil,
    catalogueNumberSecondary: GraphQLNullable<Int> = nil,
    compositionYear: GraphQLNullable<Int> = nil,
    compositionYearDesc: GraphQLNullable<String> = nil,
    pieceStyle: GraphQLNullable<String> = nil,
    wikipediaUrl: GraphQLNullable<String> = nil,
    instrumentation: GraphQLNullable<[String?]> = nil,
    compositionYearString: GraphQLNullable<String> = nil,
    subPieceType: GraphQLNullable<String> = nil,
    subPieceCount: GraphQLNullable<Int> = nil,
    imslpUrl: GraphQLNullable<String> = nil,
    imslpPieceId: GraphQLNullable<BigInt> = nil,
    totalPracticeTime: GraphQLNullable<Int> = nil,
    lastPracticed: GraphQLNullable<Datetime> = nil,
    isImslp: GraphQLNullable<Bool> = nil,
    collectionId: GraphQLNullable<BigInt> = nil
  ) {
    __data = InputDict([
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
      "collectionId": collectionId
    ])
  }

  public var workName: GraphQLNullable<String> {
    get { __data["workName"] }
    set { __data["workName"] = newValue }
  }

  public var composerId: GraphQLNullable<BigInt> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }

  public var nickname: GraphQLNullable<String> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
  }

  public var userId: GraphQLNullable<UUID> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var format: GraphQLNullable<GraphQLEnum<PieceFormat>> {
    get { __data["format"] }
    set { __data["format"] = newValue }
  }

  public var keySignature: GraphQLNullable<GraphQLEnum<KeySignatureType>> {
    get { __data["keySignature"] }
    set { __data["keySignature"] = newValue }
  }

  public var catalogueType: GraphQLNullable<GraphQLEnum<CatalogueType>> {
    get { __data["catalogueType"] }
    set { __data["catalogueType"] = newValue }
  }

  public var catalogueNumber: GraphQLNullable<Int> {
    get { __data["catalogueNumber"] }
    set { __data["catalogueNumber"] = newValue }
  }

  public var updatedAt: GraphQLNullable<Datetime> {
    get { __data["updatedAt"] }
    set { __data["updatedAt"] = newValue }
  }

  public var createdAt: GraphQLNullable<Datetime> {
    get { __data["createdAt"] }
    set { __data["createdAt"] = newValue }
  }

  public var searchableText: GraphQLNullable<String> {
    get { __data["searchableText"] }
    set { __data["searchableText"] = newValue }
  }

  public var catalogueTypeNumDesc: GraphQLNullable<String> {
    get { __data["catalogueTypeNumDesc"] }
    set { __data["catalogueTypeNumDesc"] = newValue }
  }

  public var catalogueNumberSecondary: GraphQLNullable<Int> {
    get { __data["catalogueNumberSecondary"] }
    set { __data["catalogueNumberSecondary"] = newValue }
  }

  public var compositionYear: GraphQLNullable<Int> {
    get { __data["compositionYear"] }
    set { __data["compositionYear"] = newValue }
  }

  public var compositionYearDesc: GraphQLNullable<String> {
    get { __data["compositionYearDesc"] }
    set { __data["compositionYearDesc"] = newValue }
  }

  public var pieceStyle: GraphQLNullable<String> {
    get { __data["pieceStyle"] }
    set { __data["pieceStyle"] = newValue }
  }

  public var wikipediaUrl: GraphQLNullable<String> {
    get { __data["wikipediaUrl"] }
    set { __data["wikipediaUrl"] = newValue }
  }

  public var instrumentation: GraphQLNullable<[String?]> {
    get { __data["instrumentation"] }
    set { __data["instrumentation"] = newValue }
  }

  public var compositionYearString: GraphQLNullable<String> {
    get { __data["compositionYearString"] }
    set { __data["compositionYearString"] = newValue }
  }

  public var subPieceType: GraphQLNullable<String> {
    get { __data["subPieceType"] }
    set { __data["subPieceType"] = newValue }
  }

  public var subPieceCount: GraphQLNullable<Int> {
    get { __data["subPieceCount"] }
    set { __data["subPieceCount"] = newValue }
  }

  public var imslpUrl: GraphQLNullable<String> {
    get { __data["imslpUrl"] }
    set { __data["imslpUrl"] = newValue }
  }

  public var imslpPieceId: GraphQLNullable<BigInt> {
    get { __data["imslpPieceId"] }
    set { __data["imslpPieceId"] = newValue }
  }

  public var totalPracticeTime: GraphQLNullable<Int> {
    get { __data["totalPracticeTime"] }
    set { __data["totalPracticeTime"] = newValue }
  }

  public var lastPracticed: GraphQLNullable<Datetime> {
    get { __data["lastPracticed"] }
    set { __data["lastPracticed"] = newValue }
  }

  public var isImslp: GraphQLNullable<Bool> {
    get { __data["isImslp"] }
    set { __data["isImslp"] = newValue }
  }

  public var collectionId: GraphQLNullable<BigInt> {
    get { __data["collectionId"] }
    set { __data["collectionId"] = newValue }
  }
}
