// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class PiecesEdge: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.PiecesEdge
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<PiecesEdge>]

    public struct MockFields {
        @Field<Pieces>("node") public var node
    }
}

public extension Mock where O == PiecesEdge {
    convenience init(
        node: Mock<Pieces>? = nil
    ) {
        self.init()
        _setEntity(node, for: \.node)
    }
}
