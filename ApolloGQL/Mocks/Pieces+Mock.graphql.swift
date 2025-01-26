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
    @Field<Int>("catalogueNumberSecondary") public var catalogueNumberSecondary
    @Field<GraphQLEnum<ApolloGQL.CatalogueType>>("catalogueType") public var catalogueType
    @Field<String>("catalogueTypeNumDesc") public var catalogueTypeNumDesc
    @Field<Composers>("composer") public var composer
    @Field<ApolloGQL.BigInt>("composerId") public var composerId
    @Field<Int>("compositionYear") public var compositionYear
    @Field<String>("compositionYearDesc") public var compositionYearDesc
    @Field<String>("compositionYearString") public var compositionYearString
    @Field<GraphQLEnum<ApolloGQL.PieceFormat>>("format") public var format
    @Field<ApolloGQL.BigInt>("id") public var id
    @Field<ApolloGQL.BigInt>("imslpPieceId") public var imslpPieceId
    @Field<String>("imslpUrl") public var imslpUrl
    @Field<[String?]>("instrumentation") public var instrumentation
    @Field<GraphQLEnum<ApolloGQL.KeySignatureType>>("keySignature") public var keySignature
    @Field<MovementsConnection>("movements") public var movements
    @Field<String>("nickname") public var nickname
    @Field<String>("pieceStyle") public var pieceStyle
    @Field<Int>("subPieceCount") public var subPieceCount
    @Field<String>("subPieceType") public var subPieceType
    @Field<String>("wikipediaUrl") public var wikipediaUrl
    @Field<String>("workName") public var workName
  }
}

public extension Mock where O == Pieces {
  convenience init(
    catalogueNumber: Int? = nil,
    catalogueNumberSecondary: Int? = nil,
    catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
    catalogueTypeNumDesc: String? = nil,
    composer: Mock<Composers>? = nil,
    composerId: ApolloGQL.BigInt? = nil,
    compositionYear: Int? = nil,
    compositionYearDesc: String? = nil,
    compositionYearString: String? = nil,
    format: GraphQLEnum<ApolloGQL.PieceFormat>? = nil,
    id: ApolloGQL.BigInt? = nil,
    imslpPieceId: ApolloGQL.BigInt? = nil,
    imslpUrl: String? = nil,
    instrumentation: [String]? = nil,
    keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
    movements: Mock<MovementsConnection>? = nil,
    nickname: String? = nil,
    pieceStyle: String? = nil,
    subPieceCount: Int? = nil,
    subPieceType: String? = nil,
    wikipediaUrl: String? = nil,
    workName: String? = nil
  ) {
    self.init()
    _setScalar(catalogueNumber, for: \.catalogueNumber)
    _setScalar(catalogueNumberSecondary, for: \.catalogueNumberSecondary)
    _setScalar(catalogueType, for: \.catalogueType)
    _setScalar(catalogueTypeNumDesc, for: \.catalogueTypeNumDesc)
    _setEntity(composer, for: \.composer)
    _setScalar(composerId, for: \.composerId)
    _setScalar(compositionYear, for: \.compositionYear)
    _setScalar(compositionYearDesc, for: \.compositionYearDesc)
    _setScalar(compositionYearString, for: \.compositionYearString)
    _setScalar(format, for: \.format)
    _setScalar(id, for: \.id)
    _setScalar(imslpPieceId, for: \.imslpPieceId)
    _setScalar(imslpUrl, for: \.imslpUrl)
    _setScalarList(instrumentation, for: \.instrumentation)
    _setScalar(keySignature, for: \.keySignature)
    _setEntity(movements, for: \.movements)
    _setScalar(nickname, for: \.nickname)
    _setScalar(pieceStyle, for: \.pieceStyle)
    _setScalar(subPieceCount, for: \.subPieceCount)
    _setScalar(subPieceType, for: \.subPieceType)
    _setScalar(wikipediaUrl, for: \.wikipediaUrl)
    _setScalar(workName, for: \.workName)
  }
}
