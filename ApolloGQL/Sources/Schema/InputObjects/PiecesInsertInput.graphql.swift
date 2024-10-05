// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PiecesInsertInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<UUID> = nil,
    workName: GraphQLNullable<String> = nil,
    composerId: GraphQLNullable<BigInt> = nil,
    userId: GraphQLNullable<UUID> = nil,
    format: GraphQLNullable<GraphQLEnum<PieceFormat>> = nil,
    keySignature: GraphQLNullable<GraphQLEnum<KeySignatureType>> = nil,
    tonality: GraphQLNullable<GraphQLEnum<KeySignatureTonality>> = nil,
    catalogueType: GraphQLNullable<GraphQLEnum<CatalogueType>> = nil,
    catalogueNumber: GraphQLNullable<Int> = nil,
    updatedAt: GraphQLNullable<Datetime> = nil,
    createdAt: GraphQLNullable<Datetime> = nil,
    nickname: GraphQLNullable<String> = nil
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
      "nickname": nickname
    ])
  }

  public var id: GraphQLNullable<UUID> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var workName: GraphQLNullable<String> {
    get { __data["workName"] }
    set { __data["workName"] = newValue }
  }

  public var composerId: GraphQLNullable<BigInt> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
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

  public var tonality: GraphQLNullable<GraphQLEnum<KeySignatureTonality>> {
    get { __data["tonality"] }
    set { __data["tonality"] = newValue }
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

  public var nickname: GraphQLNullable<String> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
  }
}
