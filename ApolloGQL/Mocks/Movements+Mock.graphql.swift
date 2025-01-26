// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class Movements: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.Movements
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Movements>>

  public struct MockFields {
    @Field<String>("downloadUrl") public var downloadUrl
    @Field<ApolloGQL.BigInt>("id") public var id
    @Field<GraphQLEnum<ApolloGQL.KeySignatureType>>("keySignature") public var keySignature
    @Field<String>("name") public var name
    @Field<String>("nickname") public var nickname
    @Field<Int>("number") public var number
    @Field<ApolloGQL.BigInt>("pieceId") public var pieceId
  }
}

public extension Mock where O == Movements {
  convenience init(
    downloadUrl: String? = nil,
    id: ApolloGQL.BigInt? = nil,
    keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
    name: String? = nil,
    nickname: String? = nil,
    number: Int? = nil,
    pieceId: ApolloGQL.BigInt? = nil
  ) {
    self.init()
    _setScalar(downloadUrl, for: \.downloadUrl)
    _setScalar(id, for: \.id)
    _setScalar(keySignature, for: \.keySignature)
    _setScalar(name, for: \.name)
    _setScalar(nickname, for: \.nickname)
    _setScalar(number, for: \.number)
    _setScalar(pieceId, for: \.pieceId)
  }
}
