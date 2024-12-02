// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import ApolloGQL

public class Pieces: MockObject {
  public static let objectType: ApolloAPI.Object = ApolloGQL.Objects.Pieces
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Pieces>>

  public struct MockFields {
    @Field<Int>("catalogueNumber") public var catalogueNumber
    @Field<GraphQLEnum<ApolloGQL.CatalogueType>>("catalogueType") public var catalogueType
    @Field<Composers>("composer") public var composer
    @Field<ApolloGQL.BigInt>("composerId") public var composerId
    @Field<ApolloGQL.BigInt>("id") public var id
    @Field<GraphQLEnum<ApolloGQL.KeySignatureType>>("keySignature") public var keySignature
    @Field<MovementsConnection>("movements") public var movements
    @Field<MovementsConnection>("movementsCollection") public var movementsCollection
    @Field<String>("nickname") public var nickname
    @Field<String>("workName") public var workName
  }
}

public extension Mock where O == Pieces {
  convenience init(
    catalogueNumber: Int? = nil,
    catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
    composer: Mock<Composers>? = nil,
    composerId: ApolloGQL.BigInt? = nil,
    id: ApolloGQL.BigInt? = nil,
    keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
    movements: Mock<MovementsConnection>? = nil,
    movementsCollection: Mock<MovementsConnection>? = nil,
    nickname: String? = nil,
    workName: String? = nil
  ) {
    self.init()
    _setScalar(catalogueNumber, for: \.catalogueNumber)
    _setScalar(catalogueType, for: \.catalogueType)
    _setEntity(composer, for: \.composer)
    _setScalar(composerId, for: \.composerId)
    _setScalar(id, for: \.id)
    _setScalar(keySignature, for: \.keySignature)
    _setEntity(movements, for: \.movements)
    _setEntity(movementsCollection, for: \.movementsCollection)
    _setScalar(nickname, for: \.nickname)
    _setScalar(workName, for: \.workName)
  }
}
