// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PracticeSessionsFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<BigIntFilter> = nil,
    startTime: GraphQLNullable<DatetimeFilter> = nil,
    endTime: GraphQLNullable<DatetimeFilter> = nil,
    pieceId: GraphQLNullable<BigIntFilter> = nil,
    movementId: GraphQLNullable<BigIntFilter> = nil,
    userId: GraphQLNullable<UUIDFilter> = nil,
    durationSeconds: GraphQLNullable<IntFilter> = nil,
    deletedAt: GraphQLNullable<DatetimeFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[PracticeSessionsFilter]> = nil,
    or: GraphQLNullable<[PracticeSessionsFilter]> = nil,
    not: GraphQLNullable<PracticeSessionsFilter> = nil
  ) {
    __data = InputDict([
      "id": id,
      "startTime": startTime,
      "endTime": endTime,
      "pieceId": pieceId,
      "movementId": movementId,
      "userId": userId,
      "durationSeconds": durationSeconds,
      "deletedAt": deletedAt,
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

  public var startTime: GraphQLNullable<DatetimeFilter> {
    get { __data["startTime"] }
    set { __data["startTime"] = newValue }
  }

  public var endTime: GraphQLNullable<DatetimeFilter> {
    get { __data["endTime"] }
    set { __data["endTime"] = newValue }
  }

  public var pieceId: GraphQLNullable<BigIntFilter> {
    get { __data["pieceId"] }
    set { __data["pieceId"] = newValue }
  }

  public var movementId: GraphQLNullable<BigIntFilter> {
    get { __data["movementId"] }
    set { __data["movementId"] = newValue }
  }

  public var userId: GraphQLNullable<UUIDFilter> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var durationSeconds: GraphQLNullable<IntFilter> {
    get { __data["durationSeconds"] }
    set { __data["durationSeconds"] = newValue }
  }

  public var deletedAt: GraphQLNullable<DatetimeFilter> {
    get { __data["deletedAt"] }
    set { __data["deletedAt"] = newValue }
  }

  public var nodeId: GraphQLNullable<IDFilter> {
    get { __data["nodeId"] }
    set { __data["nodeId"] = newValue }
  }

  /// Returns true only if all its inner filters are true, otherwise returns false
  public var and: GraphQLNullable<[PracticeSessionsFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[PracticeSessionsFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<PracticeSessionsFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
