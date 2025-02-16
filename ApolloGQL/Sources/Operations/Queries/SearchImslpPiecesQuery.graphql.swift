// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchImslpPiecesQuery: GraphQLQuery {
  public static let operationName: String = "SearchImslpPieces"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchImslpPieces($query: String!, $filterUserPieces: Boolean = false, $orderBy: [ImslpPieceOrderBy!] = []) { searchImslpPieces( query: $query filterUserPieces: $filterUserPieces orderBy: $orderBy ) { __typename edges { __typename node { __typename ...ImslpPieceDetails } } } }"#,
      fragments: [ImslpPieceDetails.self]
    ))

  public var query: String
  public var filterUserPieces: GraphQLNullable<Bool>
  public var orderBy: GraphQLNullable<[ImslpPieceOrderBy]>

  public init(
    query: String,
    filterUserPieces: GraphQLNullable<Bool> = false,
    orderBy: GraphQLNullable<[ImslpPieceOrderBy]> = []
  ) {
    self.query = query
    self.filterUserPieces = filterUserPieces
    self.orderBy = orderBy
  }

  public var __variables: Variables? { [
    "query": query,
    "filterUserPieces": filterUserPieces,
    "orderBy": orderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("searchImslpPieces", SearchImslpPieces?.self, arguments: [
        "query": .variable("query"),
        "filterUserPieces": .variable("filterUserPieces"),
        "orderBy": .variable("orderBy")
      ]),
    ] }

    public var searchImslpPieces: SearchImslpPieces? { __data["searchImslpPieces"] }

    public init(
      searchImslpPieces: SearchImslpPieces? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "searchImslpPieces": searchImslpPieces._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(SearchImslpPiecesQuery.Data.self)
        ]
      ))
    }

    /// SearchImslpPieces
    ///
    /// Parent Type: `ImslpPieceConnection`
    public struct SearchImslpPieces: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.ImslpPieceConnection }
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
            "__typename": ApolloGQL.Objects.ImslpPieceConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.self)
          ]
        ))
      }

      /// SearchImslpPieces.Edge
      ///
      /// Parent Type: `ImslpPieceEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.ImslpPieceEdge }
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
              "__typename": ApolloGQL.Objects.ImslpPieceEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.self)
            ]
          ))
        }

        /// SearchImslpPieces.Edge.Node
        ///
        /// Parent Type: `ImslpPiece`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.ImslpPiece }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(ImslpPieceDetails.self),
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

            public var imslpPieceDetails: ImslpPieceDetails { _toFragment() }
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
                "__typename": ApolloGQL.Objects.ImslpPiece.typename,
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
                ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.Node.self),
                ObjectIdentifier(ImslpPieceDetails.self)
              ]
            ))
          }

          public typealias Composer = ImslpPieceDetails.Composer

          public typealias Movements = ImslpPieceDetails.Movements
        }
      }
    }
  }
}
