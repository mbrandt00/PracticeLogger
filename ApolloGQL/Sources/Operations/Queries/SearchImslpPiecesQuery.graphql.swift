// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchImslpPiecesQuery: GraphQLQuery {
  public static let operationName: String = "SearchImslpPieces"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchImslpPieces($query: String!) { searchImslpPieces(query: $query) { __typename edges { __typename node { __typename id workName ...PieceDetails catalogueNumber catalogueType composerId keySignature movementsCollection { __typename edges { __typename node { __typename nickname number name } } } } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var query: String

  public init(query: String) {
    self.query = query
  }

  public var __variables: Variables? { ["query": query] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("searchImslpPieces", SearchImslpPieces?.self, arguments: ["query": .variable("query")]),
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
    /// Parent Type: `PiecesConnection`
    public struct SearchImslpPieces: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PiecesConnection }
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
            "__typename": ApolloGQL.Objects.PiecesConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.self)
          ]
        ))
      }

      /// SearchImslpPieces.Edge
      ///
      /// Parent Type: `PiecesEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PiecesEdge }
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
              "__typename": ApolloGQL.Objects.PiecesEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.self)
            ]
          ))
        }

        /// SearchImslpPieces.Edge.Node
        ///
        /// Parent Type: `Pieces`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Pieces }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ApolloGQL.BigInt.self),
            .field("workName", String.self),
            .field("catalogueNumber", Int?.self),
            .field("catalogueType", GraphQLEnum<ApolloGQL.CatalogueType>?.self),
            .field("composerId", ApolloGQL.BigInt?.self),
            .field("keySignature", GraphQLEnum<ApolloGQL.KeySignatureType>?.self),
            .field("movementsCollection", MovementsCollection?.self),
            .fragment(PieceDetails.self),
          ] }

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var workName: String { __data["workName"] }
          public var catalogueNumber: Int? { __data["catalogueNumber"] }
          public var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? { __data["catalogueType"] }
          public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
          public var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { __data["keySignature"] }
          public var movementsCollection: MovementsCollection? { __data["movementsCollection"] }
          public var format: GraphQLEnum<ApolloGQL.PieceFormat>? { __data["format"] }
          public var nickname: String? { __data["nickname"] }
          public var composer: Composer? { __data["composer"] }
          public var movements: Movements? { __data["movements"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pieceDetails: PieceDetails { _toFragment() }
          }

          public init(
            id: ApolloGQL.BigInt,
            workName: String,
            catalogueNumber: Int? = nil,
            catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
            composerId: ApolloGQL.BigInt? = nil,
            keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
            movementsCollection: MovementsCollection? = nil,
            format: GraphQLEnum<ApolloGQL.PieceFormat>? = nil,
            nickname: String? = nil,
            composer: Composer? = nil,
            movements: Movements? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Pieces.typename,
                "id": id,
                "workName": workName,
                "catalogueNumber": catalogueNumber,
                "catalogueType": catalogueType,
                "composerId": composerId,
                "keySignature": keySignature,
                "movementsCollection": movementsCollection._fieldData,
                "format": format,
                "nickname": nickname,
                "composer": composer._fieldData,
                "movements": movements._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.Node.self),
                ObjectIdentifier(PieceDetails.self)
              ]
            ))
          }

          /// SearchImslpPieces.Edge.Node.MovementsCollection
          ///
          /// Parent Type: `MovementsConnection`
          public struct MovementsCollection: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementsConnection }
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
                  "__typename": ApolloGQL.Objects.MovementsConnection.typename,
                  "edges": edges._fieldData,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.Node.MovementsCollection.self)
                ]
              ))
            }

            /// SearchImslpPieces.Edge.Node.MovementsCollection.Edge
            ///
            /// Parent Type: `MovementsEdge`
            public struct Edge: ApolloGQL.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementsEdge }
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
                    "__typename": ApolloGQL.Objects.MovementsEdge.typename,
                    "node": node._fieldData,
                  ],
                  fulfilledFragments: [
                    ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.Node.MovementsCollection.Edge.self)
                  ]
                ))
              }

              /// SearchImslpPieces.Edge.Node.MovementsCollection.Edge.Node
              ///
              /// Parent Type: `Movements`
              public struct Node: ApolloGQL.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movements }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("nickname", String?.self),
                  .field("number", Int?.self),
                  .field("name", String?.self),
                ] }

                public var nickname: String? { __data["nickname"] }
                public var number: Int? { __data["number"] }
                public var name: String? { __data["name"] }

                public init(
                  nickname: String? = nil,
                  number: Int? = nil,
                  name: String? = nil
                ) {
                  self.init(_dataDict: DataDict(
                    data: [
                      "__typename": ApolloGQL.Objects.Movements.typename,
                      "nickname": nickname,
                      "number": number,
                      "name": name,
                    ],
                    fulfilledFragments: [
                      ObjectIdentifier(SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.Node.MovementsCollection.Edge.Node.self)
                    ]
                  ))
                }
              }
            }
          }

          public typealias Composer = PieceDetails.Composer

          public typealias Movements = PieceDetails.Movements
        }
      }
    }
  }
}
