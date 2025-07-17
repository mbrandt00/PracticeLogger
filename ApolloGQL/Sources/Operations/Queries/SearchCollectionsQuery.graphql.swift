// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchCollectionsQuery: GraphQLQuery {
  public static let operationName: String = "SearchCollections"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchCollections($query: String!, $collectionsFilter: CollectionsFilter = {  }, $collectionsOrderBy: [CollectionsOrderBy!] = [], $piecesOrderBy: [PieceOrderBy!] = []) { searchCollections( query: $query filter: $collectionsFilter orderBy: $collectionsOrderBy ) { __typename edges { __typename node { __typename pieces(orderBy: $piecesOrderBy) { __typename edges { __typename node { __typename ...PieceDetails } } } name composer { __typename lastName firstName } } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var query: String
  public var collectionsFilter: GraphQLNullable<CollectionsFilter>
  public var collectionsOrderBy: GraphQLNullable<[CollectionsOrderBy]>
  public var piecesOrderBy: GraphQLNullable<[PieceOrderBy]>

  public init(
    query: String,
    collectionsFilter: GraphQLNullable<CollectionsFilter> = .init(
      CollectionsFilter()
    ),
    collectionsOrderBy: GraphQLNullable<[CollectionsOrderBy]> = [],
    piecesOrderBy: GraphQLNullable<[PieceOrderBy]> = []
  ) {
    self.query = query
    self.collectionsFilter = collectionsFilter
    self.collectionsOrderBy = collectionsOrderBy
    self.piecesOrderBy = piecesOrderBy
  }

  public var __variables: Variables? { [
    "query": query,
    "collectionsFilter": collectionsFilter,
    "collectionsOrderBy": collectionsOrderBy,
    "piecesOrderBy": piecesOrderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("searchCollections", SearchCollections?.self, arguments: [
        "query": .variable("query"),
        "filter": .variable("collectionsFilter"),
        "orderBy": .variable("collectionsOrderBy")
      ]),
    ] }

    public var searchCollections: SearchCollections? { __data["searchCollections"] }

    public init(
      searchCollections: SearchCollections? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "searchCollections": searchCollections._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(SearchCollectionsQuery.Data.self)
        ]
      ))
    }

    /// SearchCollections
    ///
    /// Parent Type: `CollectionsConnection`
    public struct SearchCollections: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionsConnection }
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
            "__typename": ApolloGQL.Objects.CollectionsConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.self)
          ]
        ))
      }

      /// SearchCollections.Edge
      ///
      /// Parent Type: `CollectionsEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionsEdge }
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
              "__typename": ApolloGQL.Objects.CollectionsEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.Edge.self)
            ]
          ))
        }

        /// SearchCollections.Edge.Node
        ///
        /// Parent Type: `Collections`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Collections }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("pieces", Pieces?.self, arguments: ["orderBy": .variable("piecesOrderBy")]),
            .field("name", String.self),
            .field("composer", Composer?.self),
          ] }

          /// Returns pieces belonging to this collection, prioritizing user-customized pieces over default pieces with the same IMSLP URL
          public var pieces: Pieces? { __data["pieces"] }
          public var name: String { __data["name"] }
          public var composer: Composer? { __data["composer"] }

          public init(
            pieces: Pieces? = nil,
            name: String,
            composer: Composer? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Collections.typename,
                "pieces": pieces._fieldData,
                "name": name,
                "composer": composer._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.Edge.Node.self)
              ]
            ))
          }

          /// SearchCollections.Edge.Node.Pieces
          ///
          /// Parent Type: `PieceConnection`
          public struct Pieces: ApolloGQL.SelectionSet {
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
                  ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.Edge.Node.Pieces.self)
                ]
              ))
            }

            /// SearchCollections.Edge.Node.Pieces.Edge
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
                    ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.Edge.Node.Pieces.Edge.self)
                  ]
                ))
              }

              /// SearchCollections.Edge.Node.Pieces.Edge.Node
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

                public var lastPracticed: ApolloGQL.Datetime? { __data["lastPracticed"] }
                public var totalPracticeTime: Int? { __data["totalPracticeTime"] }
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
                public var searchableText: String? { __data["searchableText"] }
                public var subPieceCount: Int? { __data["subPieceCount"] }
                public var userId: ApolloGQL.UUID? { __data["userId"] }
                public var catalogueNumber: Int? { __data["catalogueNumber"] }
                public var nickname: String? { __data["nickname"] }
                public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
                public var collections: Collections? { __data["collections"] }
                public var composer: Composer? { __data["composer"] }
                public var movements: Movements? { __data["movements"] }

                public struct Fragments: FragmentContainer {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public var pieceDetails: PieceDetails { _toFragment() }
                }

                public init(
                  lastPracticed: ApolloGQL.Datetime? = nil,
                  totalPracticeTime: Int? = nil,
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
                  searchableText: String? = nil,
                  subPieceCount: Int? = nil,
                  userId: ApolloGQL.UUID? = nil,
                  catalogueNumber: Int? = nil,
                  nickname: String? = nil,
                  composerId: ApolloGQL.BigInt? = nil,
                  collections: Collections? = nil,
                  composer: Composer? = nil,
                  movements: Movements? = nil
                ) {
                  self.init(_dataDict: DataDict(
                    data: [
                      "__typename": ApolloGQL.Objects.Piece.typename,
                      "lastPracticed": lastPracticed,
                      "totalPracticeTime": totalPracticeTime,
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
                      "searchableText": searchableText,
                      "subPieceCount": subPieceCount,
                      "userId": userId,
                      "catalogueNumber": catalogueNumber,
                      "nickname": nickname,
                      "composerId": composerId,
                      "collections": collections._fieldData,
                      "composer": composer._fieldData,
                      "movements": movements._fieldData,
                    ],
                    fulfilledFragments: [
                      ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.Edge.Node.Pieces.Edge.Node.self),
                      ObjectIdentifier(PieceDetails.self)
                    ]
                  ))
                }

                public typealias Collections = PieceDetails.Collections

                public typealias Composer = PieceDetails.Composer

                public typealias Movements = PieceDetails.Movements
              }
            }
          }

          /// SearchCollections.Edge.Node.Composer
          ///
          /// Parent Type: `Composers`
          public struct Composer: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("lastName", String.self),
              .field("firstName", String.self),
            ] }

            public var lastName: String { __data["lastName"] }
            public var firstName: String { __data["firstName"] }

            public init(
              lastName: String,
              firstName: String
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": ApolloGQL.Objects.Composers.typename,
                  "lastName": lastName,
                  "firstName": firstName,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(SearchCollectionsQuery.Data.SearchCollections.Edge.Node.Composer.self)
                ]
              ))
            }
          }
        }
      }
    }
  }
}
