// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PracticeSessionsOrderBy: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    startTime: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    endTime: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    pieceId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    movementId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    durationSeconds: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    deletedAt: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil
  ) {
    __data = InputDict([
      "id": id,
      "startTime": startTime,
      "endTime": endTime,
      "pieceId": pieceId,
      "movementId": movementId,
      "userId": userId,
      "durationSeconds": durationSeconds,
      "deletedAt": deletedAt
    ])
  }

  public var id: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var startTime: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["startTime"] }
    set { __data["startTime"] = newValue }
  }

  public var endTime: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["endTime"] }
    set { __data["endTime"] = newValue }
  }

  public var pieceId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var movementId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["movementId"] }
    set { __data["movementId"] = newValue }
  }

  public var userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var durationSeconds: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["durationSeconds"] }
    set { __data["durationSeconds"] = newValue }
  }

  public var deletedAt: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["deletedAt"] }
    set { __data["deletedAt"] = newValue }
  }
}
