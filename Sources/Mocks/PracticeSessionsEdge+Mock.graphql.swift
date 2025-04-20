// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class PracticeSessionsEdge: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PracticeSessionsEdge
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<PracticeSessionsEdge>]

    public struct MockFields {
        @Field<PracticeSessions>("node") public var node
    }
}

public extension Mock where O == PracticeSessionsEdge {
    convenience init(
        node: Mock<PracticeSessions>? = nil
    ) {
        self.init()
        _setEntity(node, for: \.node)
    }
}
