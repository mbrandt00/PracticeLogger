// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PracticeSessionsInsertInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    startTime: GraphQLNullable<Datetime> = nil,
    endTime: GraphQLNullable<Datetime> = nil,
    pieceId: GraphQLNullable<BigInt> = nil,
    movementId: GraphQLNullable<BigInt> = nil,
    userId: GraphQLNullable<UUID> = nil
  ) {
    __data = InputDict([
      "startTime": startTime,
      "endTime": endTime,
      "pieceId": pieceId,
      "movementId": movementId,
      "userId": userId
    ])
  }

  public var startTime: GraphQLNullable<Datetime> {
    get { __data["startTime"] }
    set { __data["startTime"] = newValue }
  }

  public var endTime: GraphQLNullable<Datetime> {
    get { __data["endTime"] }
    set { __data["endTime"] = newValue }
  }

  public var pieceId: GraphQLNullable<BigInt> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var movementId: GraphQLNullable<BigInt> {
    get { __data["movementId"] }
    set { __data["movementId"] = newValue }
  }

  public var userId: GraphQLNullable<UUID> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }
}
