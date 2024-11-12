// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class PiecesInsertResponse: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PiecesInsertResponse
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<PiecesInsertResponse>>

  public struct MockFields {
    @Field<[Pieces]>("records") public var records
  }
}

public extension Mock where O == PiecesInsertResponse {
  convenience init(
    records: [Mock<Pieces>]? = nil
  ) {
    self.init()
    _setList(records, for: \.records)
  }
}
