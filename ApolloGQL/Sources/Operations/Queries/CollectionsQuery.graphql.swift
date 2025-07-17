// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CollectionsQuery: GraphQLQuery {
  public static let operationName: String = "CollectionsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CollectionsQuery($filter: CollectionsFilter = {  }, $orderBy: [CollectionsOrderBy!] = [], $piecesOrderBy: [CollectionPiecesOrderBy!] = []) { collectionsCollection(filter: $filter, orderBy: $orderBy) { __typename edges { __typename node { __typename id name userId composer { __typename firstName lastName } collectionPieces(orderBy: $piecesOrderBy, first: 1000) { __typename edges { __typename node { __typename id piece { __typename ...PieceDetails id workName catalogueNumber catalogueNumberSecondary totalPracticeTime userId } } } } } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var filter: GraphQLNullable<CollectionsFilter>
  public var orderBy: GraphQLNullable<[CollectionsOrderBy]>
  public var piecesOrderBy: GraphQLNullable<[CollectionPiecesOrderBy]>

  public init(
    filter: GraphQLNullable<CollectionsFilter> = .init(
      CollectionsFilter()
    ),
    orderBy: GraphQLNullable<[CollectionsOrderBy]> = [],
    piecesOrderBy: GraphQLNullable<[CollectionPiecesOrderBy]> = []
  ) {
    self.filter = filter
    self.orderBy = orderBy
    self.piecesOrderBy = piecesOrderBy
  }

  public var __variables: Variables? { [
    "filter": filter,
    "orderBy": orderBy,
    "piecesOrderBy": piecesOrderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("collectionsCollection", CollectionsCollection?.self, arguments: [
        "filter": .variable("filter"),
        "orderBy": .variable("orderBy")
      ]),
    ] }

    /// A pagable collection of type `Collections`
    public var collectionsCollection: CollectionsCollection? { __data["collectionsCollection"] }

    public init(
      collectionsCollection: CollectionsCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "collectionsCollection": collectionsCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CollectionsQuery.Data.self)
        ]
      ))
    }

    /// CollectionsCollection
    ///
    /// Parent Type: `CollectionsConnection`
    public struct CollectionsCollection: ApolloGQL.SelectionSet {
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
            ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.self)
          ]
        ))
      }

      /// CollectionsCollection.Edge
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
              ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.self)
            ]
          ))
        }

        /// CollectionsCollection.Edge.Node
        ///
        /// Parent Type: `Collections`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Collections }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ApolloGQL.BigInt.self),
            .field("name", String.self),
            .field("userId", ApolloGQL.UUID?.self),
            .field("composer", Composer?.self),
            .field("collectionPieces", CollectionPieces?.self, arguments: [
              "orderBy": .variable("piecesOrderBy"),
              "first": 1000
            ]),
          ] }

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var name: String { __data["name"] }
          public var userId: ApolloGQL.UUID? { __data["userId"] }
          public var composer: Composer? { __data["composer"] }
          public var collectionPieces: CollectionPieces? { __data["collectionPieces"] }

          public init(
            id: ApolloGQL.BigInt,
            name: String,
            userId: ApolloGQL.UUID? = nil,
            composer: Composer? = nil,
            collectionPieces: CollectionPieces? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Collections.typename,
                "id": id,
                "name": name,
                "userId": userId,
                "composer": composer._fieldData,
                "collectionPieces": collectionPieces._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.self)
              ]
            ))
          }

          /// CollectionsCollection.Edge.Node.Composer
          ///
          /// Parent Type: `Composers`
          public struct Composer: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("firstName", String.self),
              .field("lastName", String.self),
            ] }

            public var firstName: String { __data["firstName"] }
            public var lastName: String { __data["lastName"] }

            public init(
              firstName: String,
              lastName: String
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": ApolloGQL.Objects.Composers.typename,
                  "firstName": firstName,
                  "lastName": lastName,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.Composer.self)
                ]
              ))
            }
          }

          /// CollectionsCollection.Edge.Node.CollectionPieces
          ///
          /// Parent Type: `CollectionPiecesConnection`
          public struct CollectionPieces: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionPiecesConnection }
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
                  "__typename": ApolloGQL.Objects.CollectionPiecesConnection.typename,
                  "edges": edges._fieldData,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.CollectionPieces.self)
                ]
              ))
            }

            /// CollectionsCollection.Edge.Node.CollectionPieces.Edge
            ///
            /// Parent Type: `CollectionPiecesEdge`
            public struct Edge: ApolloGQL.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionPiecesEdge }
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
                    "__typename": ApolloGQL.Objects.CollectionPiecesEdge.typename,
                    "node": node._fieldData,
                  ],
                  fulfilledFragments: [
                    ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.CollectionPieces.Edge.self)
                  ]
                ))
              }

              /// CollectionsCollection.Edge.Node.CollectionPieces.Edge.Node
              ///
              /// Parent Type: `CollectionPieces`
              public struct Node: ApolloGQL.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionPieces }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("id", ApolloGQL.BigInt.self),
                  .field("piece", Piece.self),
                ] }

                public var id: ApolloGQL.BigInt { __data["id"] }
                public var piece: Piece { __data["piece"] }

                public init(
                  id: ApolloGQL.BigInt,
                  piece: Piece
                ) {
                  self.init(_dataDict: DataDict(
                    data: [
                      "__typename": ApolloGQL.Objects.CollectionPieces.typename,
                      "id": id,
                      "piece": piece._fieldData,
                    ],
                    fulfilledFragments: [
                      ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.CollectionPieces.Edge.Node.self)
                    ]
                  ))
                }

                /// CollectionsCollection.Edge.Node.CollectionPieces.Edge.Node.Piece
                ///
                /// Parent Type: `Piece`
                public struct Piece: ApolloGQL.SelectionSet {
                  public let __data: DataDict
                  public init(_dataDict: DataDict) { __data = _dataDict }

                  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
                  public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("id", ApolloGQL.BigInt.self),
                    .field("workName", String.self),
                    .field("catalogueNumber", Int?.self),
                    .field("catalogueNumberSecondary", Int?.self),
                    .field("totalPracticeTime", Int?.self),
                    .field("userId", ApolloGQL.UUID?.self),
                    .fragment(PieceDetails.self),
                  ] }

                  public var id: ApolloGQL.BigInt { __data["id"] }
                  public var workName: String { __data["workName"] }
                  public var catalogueNumber: Int? { __data["catalogueNumber"] }
                  public var catalogueNumberSecondary: Int? { __data["catalogueNumberSecondary"] }
                  public var totalPracticeTime: Int? { __data["totalPracticeTime"] }
                  public var userId: ApolloGQL.UUID? { __data["userId"] }
                  public var lastPracticed: ApolloGQL.Datetime? { __data["lastPracticed"] }
                  public var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? { __data["catalogueType"] }
                  public var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { __data["keySignature"] }
                  public var format: GraphQLEnum<ApolloGQL.PieceFormat>? { __data["format"] }
                  public var instrumentation: [String?]? { __data["instrumentation"] }
                  public var wikipediaUrl: String? { __data["wikipediaUrl"] }
                  public var imslpUrl: String? { __data["imslpUrl"] }
                  public var compositionYear: Int? { __data["compositionYear"] }
                  public var catalogueTypeNumDesc: String? { __data["catalogueTypeNumDesc"] }
                  public var compositionYearDesc: String? { __data["compositionYearDesc"] }
                  public var compositionYearString: String? { __data["compositionYearString"] }
                  public var pieceStyle: String? { __data["pieceStyle"] }
                  public var subPieceType: String? { __data["subPieceType"] }
                  public var searchableText: String? { __data["searchableText"] }
                  public var subPieceCount: Int? { __data["subPieceCount"] }
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
                    id: ApolloGQL.BigInt,
                    workName: String,
                    catalogueNumber: Int? = nil,
                    catalogueNumberSecondary: Int? = nil,
                    totalPracticeTime: Int? = nil,
                    userId: ApolloGQL.UUID? = nil,
                    lastPracticed: ApolloGQL.Datetime? = nil,
                    catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
                    keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
                    format: GraphQLEnum<ApolloGQL.PieceFormat>? = nil,
                    instrumentation: [String?]? = nil,
                    wikipediaUrl: String? = nil,
                    imslpUrl: String? = nil,
                    compositionYear: Int? = nil,
                    catalogueTypeNumDesc: String? = nil,
                    compositionYearDesc: String? = nil,
                    compositionYearString: String? = nil,
                    pieceStyle: String? = nil,
                    subPieceType: String? = nil,
                    searchableText: String? = nil,
                    subPieceCount: Int? = nil,
                    nickname: String? = nil,
                    composerId: ApolloGQL.BigInt? = nil,
                    collections: Collections? = nil,
                    composer: Composer? = nil,
                    movements: Movements? = nil
                  ) {
                    self.init(_dataDict: DataDict(
                      data: [
                        "__typename": ApolloGQL.Objects.Piece.typename,
                        "id": id,
                        "workName": workName,
                        "catalogueNumber": catalogueNumber,
                        "catalogueNumberSecondary": catalogueNumberSecondary,
                        "totalPracticeTime": totalPracticeTime,
                        "userId": userId,
                        "lastPracticed": lastPracticed,
                        "catalogueType": catalogueType,
                        "keySignature": keySignature,
                        "format": format,
                        "instrumentation": instrumentation,
                        "wikipediaUrl": wikipediaUrl,
                        "imslpUrl": imslpUrl,
                        "compositionYear": compositionYear,
                        "catalogueTypeNumDesc": catalogueTypeNumDesc,
                        "compositionYearDesc": compositionYearDesc,
                        "compositionYearString": compositionYearString,
                        "pieceStyle": pieceStyle,
                        "subPieceType": subPieceType,
                        "searchableText": searchableText,
                        "subPieceCount": subPieceCount,
                        "nickname": nickname,
                        "composerId": composerId,
                        "collections": collections._fieldData,
                        "composer": composer._fieldData,
                        "movements": movements._fieldData,
                      ],
                      fulfilledFragments: [
                        ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.CollectionPieces.Edge.Node.Piece.self),
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
          }
        }
      }
    }
  }
}
