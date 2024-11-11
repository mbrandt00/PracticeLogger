// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class PracticeSessionsInsertResponse: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PracticeSessionsInsertResponse
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<PracticeSessionsInsertResponse>>

  public struct MockFields {
    @Field<[PracticeSessions]>("records") public var records
  }
}

public extension Mock where O == PracticeSessionsInsertResponse {
  convenience init(
    records: [Mock<PracticeSessions>]? = nil
  ) {
    self.init()
    _setList(records, for: \.records)
  }
}
