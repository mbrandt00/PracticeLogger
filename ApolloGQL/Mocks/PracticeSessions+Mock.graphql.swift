// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class PracticeSessions: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PracticeSessions
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<PracticeSessions>>

  public struct MockFields {
    @Field<Int>("durationSeconds") public var durationSeconds
    @Field<ApolloGQL.Datetime>("endTime") public var endTime
    @Field<ApolloGQL.BigInt>("id") public var id
    @Field<Movements>("movement") public var movement
    @Field<Pieces>("piece") public var piece
    @Field<ApolloGQL.Datetime>("startTime") public var startTime
  }
}

public extension Mock where O == PracticeSessions {
  convenience init(
    durationSeconds: Int? = nil,
    endTime: ApolloGQL.Datetime? = nil,
    id: ApolloGQL.BigInt? = nil,
    movement: Mock<Movements>? = nil,
    piece: Mock<Pieces>? = nil,
    startTime: ApolloGQL.Datetime? = nil
  ) {
    self.init()
    _setScalar(durationSeconds, for: \.durationSeconds)
    _setScalar(endTime, for: \.endTime)
    _setScalar(id, for: \.id)
    _setEntity(movement, for: \.movement)
    _setEntity(piece, for: \.piece)
    _setScalar(startTime, for: \.startTime)
  }
}
