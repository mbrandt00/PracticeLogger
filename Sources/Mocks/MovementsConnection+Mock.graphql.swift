// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class MovementsConnection: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.MovementsConnection
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<MovementsConnection>]

    public struct MockFields {
        @Field<[MovementsEdge]>("edges") public var edges
    }
}

public extension Mock where O == MovementsConnection {
    convenience init(
        edges: [Mock<MovementsEdge>]? = nil
    ) {
        self.init()
        _setList(edges, for: \.edges)
    }
}
