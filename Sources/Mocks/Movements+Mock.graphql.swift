// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class Movements: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.Movements
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<Movements>]

    public struct MockFields {
        @Field<ApolloGQL.BigInt>("id") public var id
        @Field<String>("name") public var name
        @Field<Int>("number") public var number
    }
}

public extension Mock where O == Movements {
    convenience init(
        id: ApolloGQL.BigInt? = nil,
        name: String? = nil,
        number: Int? = nil
    ) {
        self.init()
        _setScalar(id, for: \.id)
        _setScalar(name, for: \.name)
        _setScalar(number, for: \.number)
    }
}
