// @generated
// This file was automatically generated and should not be edited.

import ApolloGQL
import ApolloTestSupport

public class Composers: MockObject {
    public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.Composers
    public static let _mockFields = MockFields()
    public typealias MockValueCollectionType = [Mock<Composers>]

    public struct MockFields {
        @Field<String>("name") public var name
    }
}

public extension Mock where O == Composers {
    convenience init(
        name: String? = nil
    ) {
        self.init()
        _setScalar(name, for: \.name)
    }
}
