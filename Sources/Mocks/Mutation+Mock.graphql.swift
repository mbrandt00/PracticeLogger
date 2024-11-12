// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class Mutation: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.Mutation
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Mutation>>

  public struct MockFields {
    @Field<MovementsInsertResponse>("insertIntoMovementsCollection") public var insertIntoMovementsCollection
    @Field<PiecesInsertResponse>("insertIntoPiecesCollection") public var insertIntoPiecesCollection
    @Field<PracticeSessionsInsertResponse>("insertIntoPracticeSessionsCollection") public var insertIntoPracticeSessionsCollection
  }
}

public extension Mock where O == Mutation {
  convenience init(
    insertIntoMovementsCollection: Mock<MovementsInsertResponse>? = nil,
    insertIntoPiecesCollection: Mock<PiecesInsertResponse>? = nil,
    insertIntoPracticeSessionsCollection: Mock<PracticeSessionsInsertResponse>? = nil
  ) {
    self.init()
    _setEntity(insertIntoMovementsCollection, for: \.insertIntoMovementsCollection)
    _setEntity(insertIntoPiecesCollection, for: \.insertIntoPiecesCollection)
    _setEntity(insertIntoPracticeSessionsCollection, for: \.insertIntoPracticeSessionsCollection)
  }
}
