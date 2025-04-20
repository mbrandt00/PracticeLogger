// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class MovementsEdge: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.MovementsEdge
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<MovementsEdge>]

    public struct MockFields {
        @Field<Movements>("node") public var node
    }
}

public extension Mock where O == MovementsEdge {
    convenience init(
        node: Mock<Movements>? = nil
    ) {
        self.init()
        _setEntity(node, for: \.node)
    }
}
