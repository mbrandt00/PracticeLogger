// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct MovementInsertInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    pieceId: GraphQLNullable<BigInt> = nil,
    name: GraphQLNullable<String> = nil,
    number: GraphQLNullable<Int> = nil,
    keySignature: GraphQLNullable<GraphQLEnum<KeySignatureType>> = nil,
    nickname: GraphQLNullable<String> = nil,
    downloadUrl: GraphQLNullable<String> = nil,
    totalPracticeTime: GraphQLNullable<Int> = nil,
    lastPracticed: GraphQLNullable<Datetime> = nil,
    isImslp: GraphQLNullable<Bool> = nil,
    imslpMovementId: GraphQLNullable<BigInt> = nil
  ) {
    __data = InputDict([
      "pieceId": pieceId,
      "name": name,
      "number": number,
      "keySignature": keySignature,
      "nickname": nickname,
      "downloadUrl": downloadUrl,
      "totalPracticeTime": totalPracticeTime,
      "lastPracticed": lastPracticed,
      "isImslp": isImslp,
      "imslpMovementId": imslpMovementId
    ])
  }

  public var pieceId: GraphQLNullable<BigInt> {
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

  public var keySignature: GraphQLNullable<GraphQLEnum<KeySignatureType>> {
    get { __data["keySignature"] }
    set { __data["keySignature"] = newValue }
  }

  public var nickname: GraphQLNullable<String> {
    get { __data["nickname"] }
    set { __data["nickname"] = newValue }
  }

  public var downloadUrl: GraphQLNullable<String> {
    get { __data["downloadUrl"] }
    set { __data["downloadUrl"] = newValue }
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

  public var imslpMovementId: GraphQLNullable<BigInt> {
    get { __data["imslpMovementId"] }
    set { __data["imslpMovementId"] = newValue }
  }
}
