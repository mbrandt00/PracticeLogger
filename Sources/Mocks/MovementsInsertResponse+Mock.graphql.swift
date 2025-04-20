// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class MovementsInsertResponse: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.MovementsInsertResponse
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<MovementsInsertResponse>]

    public struct MockFields {
        @Field<[Movements]>("records") public var records
    }
}

public extension Mock where O == MovementsInsertResponse {
    convenience init(
        records: [Mock<Movements>]? = nil
    ) {
        self.init()
        _setList(records, for: \.records)
    }
}
