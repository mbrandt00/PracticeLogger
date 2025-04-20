// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class PracticeSessionsConnection: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PracticeSessionsConnection
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<PracticeSessionsConnection>]

    public struct MockFields {
        @Field<[PracticeSessionsEdge]>("edges") public var edges
    }
}

public extension Mock where O == PracticeSessionsConnection {
    convenience init(
        edges: [Mock<PracticeSessionsEdge>]? = nil
    ) {
        self.init()
        _setList(edges, for: \.edges)
    }
}
