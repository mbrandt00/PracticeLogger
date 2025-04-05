// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CollectionsQuery: GraphQLQuery {
  public static let operationName: String = "CollectionsQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CollectionsQuery($filter: CollectionsFilter = {  }, $orderBy: [CollectionsOrderBy!] = [], $piecesOrderBy: [PieceOrderBy!] = [{ catalogueNumber: AscNullsLast }]) { collectionsCollection(filter: $filter, orderBy: $orderBy) { __typename edges { __typename node { __typename name composer { __typename name } pieces(orderBy: $piecesOrderBy) { __typename edges { __typename node { __typename workName userId } } } } } } }"#
    ))

  public var filter: GraphQLNullable<CollectionsFilter>
  public var orderBy: GraphQLNullable<[CollectionsOrderBy]>
  public var piecesOrderBy: GraphQLNullable<[PieceOrderBy]>

  public init(
    filter: GraphQLNullable<CollectionsFilter> = .init(
      CollectionsFilter()
    ),
    orderBy: GraphQLNullable<[CollectionsOrderBy]> = [],
    piecesOrderBy: GraphQLNullable<[PieceOrderBy]> = [PieceOrderBy(catalogueNumber: .init(.ascNullsLast))]
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
            .field("name", String.self),
            .field("composer", Composer.self),
            .field("pieces", Pieces?.self, arguments: ["orderBy": .variable("piecesOrderBy")]),
          ] }

          public var name: String { __data["name"] }
          public var composer: Composer { __data["composer"] }
          /// Returns pieces belonging to this collection, prioritizing user-customized pieces over default pieces with the same IMSLP URL
          public var pieces: Pieces? { __data["pieces"] }

          public init(
            name: String,
            composer: Composer,
            pieces: Pieces? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Collections.typename,
                "name": name,
                "composer": composer._fieldData,
                "pieces": pieces._fieldData,
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
              .field("name", String.self),
            ] }

            public var name: String { __data["name"] }

            public init(
              name: String
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": ApolloGQL.Objects.Composers.typename,
                  "name": name,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.Composer.self)
                ]
              ))
            }
          }

          /// CollectionsCollection.Edge.Node.Pieces
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
                  ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.self)
                ]
              ))
            }

            /// CollectionsCollection.Edge.Node.Pieces.Edge
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
                    ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.self)
                  ]
                ))
              }

              /// CollectionsCollection.Edge.Node.Pieces.Edge.Node
              ///
              /// Parent Type: `Piece`
              public struct Node: ApolloGQL.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("workName", String.self),
                  .field("userId", ApolloGQL.UUID?.self),
                ] }

                public var workName: String { __data["workName"] }
                public var userId: ApolloGQL.UUID? { __data["userId"] }

                public init(
                  workName: String,
                  userId: ApolloGQL.UUID? = nil
                ) {
                  self.init(_dataDict: DataDict(
                    data: [
                      "__typename": ApolloGQL.Objects.Piece.typename,
                      "workName": workName,
                      "userId": userId,
                    ],
                    fulfilledFragments: [
                      ObjectIdentifier(CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.Node.self)
                    ]
                  ))
                }
              }
            }
          }
        }
      }
    }
  }
}
