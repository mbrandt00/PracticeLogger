// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct ImslpPieceOrderBy: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    workName: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    composerId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    nickname: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    format: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    keySignature: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    catalogueType: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    catalogueNumber: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    updatedAt: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    createdAt: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    searchableText: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    catalogueTypeNumDesc: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    catalogueNumberSecondary: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    compositionYear: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    compositionYearDesc: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    pieceStyle: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    wikipediaUrl: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    compositionYearString: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    subPieceType: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    subPieceCount: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    imslpUrl: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    collectionId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil
  ) {
    __data = InputDict([
      "id": id,
      "workName": workName,
      "composerId": composerId,
      "nickname": nickname,
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
      "compositionYearString": compositionYearString,
      "subPieceType": subPieceType,
      "subPieceCount": subPieceCount,
      "imslpUrl": imslpUrl,
      "collectionId": collectionId
    ])
  }

  public var id: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var workName: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["workName"] }
    set { __data["workName"] = newValue }
  }

  public var composerId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }

  public var nickname: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
  }

  public var format: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["format"] }
    set { __data["format"] = newValue }
  }

  public var keySignature: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["keySignature"] }
    set { __data["keySignature"] = newValue }
  }

  public var catalogueType: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["catalogueType"] }
    set { __data["catalogueType"] = newValue }
  }

  public var catalogueNumber: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["catalogueNumber"] }
    set { __data["catalogueNumber"] = newValue }
  }

  public var updatedAt: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["updatedAt"] }
    set { __data["updatedAt"] = newValue }
  }

  public var createdAt: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["createdAt"] }
    set { __data["createdAt"] = newValue }
  }

  public var searchableText: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["searchableText"] }
    set { __data["searchableText"] = newValue }
  }

  public var catalogueTypeNumDesc: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["catalogueTypeNumDesc"] }
    set { __data["catalogueTypeNumDesc"] = newValue }
  }

  public var catalogueNumberSecondary: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["catalogueNumberSecondary"] }
    set { __data["catalogueNumberSecondary"] = newValue }
  }

  public var compositionYear: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["compositionYear"] }
    set { __data["compositionYear"] = newValue }
  }

  public var compositionYearDesc: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["compositionYearDesc"] }
    set { __data["compositionYearDesc"] = newValue }
  }

  public var pieceStyle: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["pieceStyle"] }
    set { __data["pieceStyle"] = newValue }
  }

  public var wikipediaUrl: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["wikipediaUrl"] }
    set { __data["wikipediaUrl"] = newValue }
  }

  public var compositionYearString: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["compositionYearString"] }
    set { __data["compositionYearString"] = newValue }
  }

  public var subPieceType: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["subPieceType"] }
    set { __data["subPieceType"] = newValue }
  }

  public var subPieceCount: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["subPieceCount"] }
    set { __data["subPieceCount"] = newValue }
  }

  public var imslpUrl: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["imslpUrl"] }
    set { __data["imslpUrl"] = newValue }
  }

  public var collectionId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["collectionId"] }
    set { __data["collectionId"] = newValue }
  }
}
