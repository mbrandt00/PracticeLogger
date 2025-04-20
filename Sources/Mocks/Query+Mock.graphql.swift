// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class Query: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.Query
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<Query>]

    public struct MockFields {
        @Field<PiecesConnection>("piecesCollection") public var piecesCollection
        @Field<PracticeSessionsConnection>("practiceSessionsCollection") public var practiceSessionsCollection
        @Field<PiecesConnection>("searchPieceWithAssociations") public var searchPieceWithAssociations
    }
}

public extension Mock where O == Query {
    convenience init(
        piecesCollection: Mock<PiecesConnection>? = nil,
        practiceSessionsCollection: Mock<PracticeSessionsConnection>? = nil,
        searchPieceWithAssociations: Mock<PiecesConnection>? = nil
    ) {
        self.init()
        _setEntity(piecesCollection, for: \.piecesCollection)
        _setEntity(practiceSessionsCollection, for: \.practiceSessionsCollection)
        _setEntity(searchPieceWithAssociations, for: \.searchPieceWithAssociations)
    }
}
