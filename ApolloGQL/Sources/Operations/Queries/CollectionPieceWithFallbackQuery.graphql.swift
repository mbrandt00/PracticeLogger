// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CollectionPieceWithFallbackQuery: GraphQLQuery {
  public static let operationName: String = "CollectionPieceWithFallback"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CollectionPieceWithFallback($filter: collectionPiecesWithFallbackFilter = {  }, $orderBy: [collectionPiecesWithFallbackOrderBy!] = [{ catalogueNumber: AscNullsLast }]) { collectionPiecesWithFallbackCollection(filter: $filter, orderBy: $orderBy) { __typename edges { __typename node { __typename collection { __typename name } piece { __typename workName id userId } composer { __typename name } } } } }"#
    ))

  public var filter: GraphQLNullable<CollectionPiecesWithFallbackFilter>
  public var orderBy: GraphQLNullable<[CollectionPiecesWithFallbackOrderBy]>

  public init(
    filter: GraphQLNullable<CollectionPiecesWithFallbackFilter> = .init(
      CollectionPiecesWithFallbackFilter()
    ),
    orderBy: GraphQLNullable<[CollectionPiecesWithFallbackOrderBy]> = [CollectionPiecesWithFallbackOrderBy(catalogueNumber: .init(.ascNullsLast))]
  ) {
    self.filter = filter
    self.orderBy = orderBy
  }

  public var __variables: Variables? { [
    "filter": filter,
    "orderBy": orderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("collectionPiecesWithFallbackCollection", CollectionPiecesWithFallbackCollection?.self, arguments: [
        "filter": .variable("filter"),
        "orderBy": .variable("orderBy")
      ]),
    ] }

    /// A pagable collection of type `collectionPiecesWithFallback`
    public var collectionPiecesWithFallbackCollection: CollectionPiecesWithFallbackCollection? { __data["collectionPiecesWithFallbackCollection"] }

    public init(
      collectionPiecesWithFallbackCollection: CollectionPiecesWithFallbackCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "collectionPiecesWithFallbackCollection": collectionPiecesWithFallbackCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.self)
        ]
      ))
    }

    /// CollectionPiecesWithFallbackCollection
    ///
    /// Parent Type: `CollectionPiecesWithFallbackConnection`
    public struct CollectionPiecesWithFallbackCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionPiecesWithFallbackConnection }
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
            "__typename": ApolloGQL.Objects.CollectionPiecesWithFallbackConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.self)
          ]
        ))
      }

      /// CollectionPiecesWithFallbackCollection.Edge
      ///
      /// Parent Type: `CollectionPiecesWithFallbackEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionPiecesWithFallbackEdge }
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
              "__typename": ApolloGQL.Objects.CollectionPiecesWithFallbackEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.Edge.self)
            ]
          ))
        }

        /// CollectionPiecesWithFallbackCollection.Edge.Node
        ///
        /// Parent Type: `CollectionPiecesWithFallback`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.CollectionPiecesWithFallback }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("collection", Collection?.self),
            .field("piece", Piece?.self),
            .field("composer", Composer?.self),
          ] }

          public var collection: Collection? { __data["collection"] }
          public var piece: Piece? { __data["piece"] }
          public var composer: Composer? { __data["composer"] }

          public init(
            collection: Collection? = nil,
            piece: Piece? = nil,
            composer: Composer? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.CollectionPiecesWithFallback.typename,
                "collection": collection._fieldData,
                "piece": piece._fieldData,
                "composer": composer._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.Edge.Node.self)
              ]
            ))
          }

          /// CollectionPiecesWithFallbackCollection.Edge.Node.Collection
          ///
          /// Parent Type: `Collections`
          public struct Collection: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Collections }
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
                  "__typename": ApolloGQL.Objects.Collections.typename,
                  "name": name,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.Edge.Node.Collection.self)
                ]
              ))
            }
          }

          /// CollectionPiecesWithFallbackCollection.Edge.Node.Piece
          ///
          /// Parent Type: `Piece`
          public struct Piece: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("workName", String.self),
              .field("id", ApolloGQL.BigInt.self),
              .field("userId", ApolloGQL.UUID?.self),
            ] }

            public var workName: String { __data["workName"] }
            public var id: ApolloGQL.BigInt { __data["id"] }
            public var userId: ApolloGQL.UUID? { __data["userId"] }

            public init(
              workName: String,
              id: ApolloGQL.BigInt,
              userId: ApolloGQL.UUID? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": ApolloGQL.Objects.Piece.typename,
                  "workName": workName,
                  "id": id,
                  "userId": userId,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.Edge.Node.Piece.self)
                ]
              ))
            }
          }

          /// CollectionPiecesWithFallbackCollection.Edge.Node.Composer
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
                  ObjectIdentifier(CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.Edge.Node.Composer.self)
                ]
              ))
            }
          }
        }
      }
    }
  }
}
