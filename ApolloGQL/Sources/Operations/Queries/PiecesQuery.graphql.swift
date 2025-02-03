// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PiecesQuery: GraphQLQuery {
  public static let operationName: String = "PiecesQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PiecesQuery($pieceFilter: PieceFilter!, $orderBy: [PieceOrderBy!] = []) { pieceCollection(filter: $pieceFilter, orderBy: $orderBy) { __typename edges { __typename node { __typename ...PieceDetails } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var pieceFilter: PieceFilter
  public var orderBy: GraphQLNullable<[PieceOrderBy]>

  public init(
    pieceFilter: PieceFilter,
    orderBy: GraphQLNullable<[PieceOrderBy]> = []
  ) {
    self.pieceFilter = pieceFilter
    self.orderBy = orderBy
  }

  public var __variables: Variables? { [
    "pieceFilter": pieceFilter,
    "orderBy": orderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("pieceCollection", PieceCollection?.self, arguments: [
        "filter": .variable("pieceFilter"),
        "orderBy": .variable("orderBy")
      ]),
    ] }

    /// A pagable collection of type `Piece`
    public var pieceCollection: PieceCollection? { __data["pieceCollection"] }

    public init(
      pieceCollection: PieceCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "pieceCollection": pieceCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PiecesQuery.Data.self)
        ]
      ))
    }

    /// PieceCollection
    ///
    /// Parent Type: `PieceConnection`
    public struct PieceCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PieceConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge].self),
      ] }

      public var edges: [Edge] { __data["edges"] }

      public init(
        edges: [Edge]
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": ApolloGQL.Objects.PieceConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(PiecesQuery.Data.PieceCollection.self)
          ]
        ))
      }

      /// PieceCollection.Edge
      ///
      /// Parent Type: `PieceEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PieceEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", Node.self),
        ] }

        public var node: Node { __data["node"] }

        public init(
          node: Node
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": ApolloGQL.Objects.PieceEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(PiecesQuery.Data.PieceCollection.Edge.self)
            ]
          ))
        }

        /// PieceCollection.Edge.Node
        ///
        /// Parent Type: `Piece`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PieceDetails.self),
          ] }

          public var imslpPieceId: ApolloGQL.BigInt { __data["imslpPieceId"] }
          public var id: ApolloGQL.BigInt { __data["id"] }
          public var workName: String { __data["workName"] }
          public var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? { __data["catalogueType"] }
          public var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { __data["keySignature"] }
          public var format: GraphQLEnum<ApolloGQL.PieceFormat>? { __data["format"] }
          public var instrumentation: [String?]? { __data["instrumentation"] }
          public var wikipediaUrl: String? { __data["wikipediaUrl"] }
          public var imslpUrl: String? { __data["imslpUrl"] }
          public var compositionYear: Int? { __data["compositionYear"] }
          public var catalogueNumberSecondary: Int? { __data["catalogueNumberSecondary"] }
          public var catalogueTypeNumDesc: String? { __data["catalogueTypeNumDesc"] }
          public var compositionYearDesc: String? { __data["compositionYearDesc"] }
          public var compositionYearString: String? { __data["compositionYearString"] }
          public var pieceStyle: String? { __data["pieceStyle"] }
          public var subPieceType: String? { __data["subPieceType"] }
          public var subPieceCount: Int? { __data["subPieceCount"] }
          public var catalogueNumber: Int? { __data["catalogueNumber"] }
          public var nickname: String? { __data["nickname"] }
          public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
          public var composer: Composer? { __data["composer"] }
          public var movements: Movements? { __data["movements"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pieceDetails: PieceDetails { _toFragment() }
          }

          public init(
            imslpPieceId: ApolloGQL.BigInt,
            id: ApolloGQL.BigInt,
            workName: String,
            catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
            keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
            format: GraphQLEnum<ApolloGQL.PieceFormat>? = nil,
            instrumentation: [String?]? = nil,
            wikipediaUrl: String? = nil,
            imslpUrl: String? = nil,
            compositionYear: Int? = nil,
            catalogueNumberSecondary: Int? = nil,
            catalogueTypeNumDesc: String? = nil,
            compositionYearDesc: String? = nil,
            compositionYearString: String? = nil,
            pieceStyle: String? = nil,
            subPieceType: String? = nil,
            subPieceCount: Int? = nil,
            catalogueNumber: Int? = nil,
            nickname: String? = nil,
            composerId: ApolloGQL.BigInt? = nil,
            composer: Composer? = nil,
            movements: Movements? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Piece.typename,
                "imslpPieceId": imslpPieceId,
                "id": id,
                "workName": workName,
                "catalogueType": catalogueType,
                "keySignature": keySignature,
                "format": format,
                "instrumentation": instrumentation,
                "wikipediaUrl": wikipediaUrl,
                "imslpUrl": imslpUrl,
                "compositionYear": compositionYear,
                "catalogueNumberSecondary": catalogueNumberSecondary,
                "catalogueTypeNumDesc": catalogueTypeNumDesc,
                "compositionYearDesc": compositionYearDesc,
                "compositionYearString": compositionYearString,
                "pieceStyle": pieceStyle,
                "subPieceType": subPieceType,
                "subPieceCount": subPieceCount,
                "catalogueNumber": catalogueNumber,
                "nickname": nickname,
                "composerId": composerId,
                "composer": composer._fieldData,
                "movements": movements._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(PiecesQuery.Data.PieceCollection.Edge.Node.self),
                ObjectIdentifier(PieceDetails.self)
              ]
            ))
          }

          public typealias Composer = PieceDetails.Composer

          public typealias Movements = PieceDetails.Movements
        }
      }
    }
  }
}
