// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class PiecesConnection: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PiecesConnection
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<PiecesConnection>>

  public struct MockFields {
    @Field<[PiecesEdge]>("edges") public var edges
  }
}

public extension Mock where O == PiecesConnection {
  convenience init(
    edges: [Mock<PiecesEdge>]? = nil
  ) {
    self.init()
    _setList(edges, for: \.edges)
  }
}
