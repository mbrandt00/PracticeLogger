// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ApolloGQL.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ApolloGQL.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ApolloGQL.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ApolloGQL.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "CollectionPieces": return ApolloGQL.Objects.CollectionPieces
    case "CollectionPiecesConnection": return ApolloGQL.Objects.CollectionPiecesConnection
    case "CollectionPiecesEdge": return ApolloGQL.Objects.CollectionPiecesEdge
    case "Collections": return ApolloGQL.Objects.Collections
    case "CollectionsConnection": return ApolloGQL.Objects.CollectionsConnection
    case "CollectionsEdge": return ApolloGQL.Objects.CollectionsEdge
    case "Composers": return ApolloGQL.Objects.Composers
    case "ComposersConnection": return ApolloGQL.Objects.ComposersConnection
    case "ComposersEdge": return ApolloGQL.Objects.ComposersEdge
    case "Movement": return ApolloGQL.Objects.Movement
    case "MovementConnection": return ApolloGQL.Objects.MovementConnection
    case "MovementEdge": return ApolloGQL.Objects.MovementEdge
    case "MovementInsertResponse": return ApolloGQL.Objects.MovementInsertResponse
    case "MovementUpdateResponse": return ApolloGQL.Objects.MovementUpdateResponse
    case "Mutation": return ApolloGQL.Objects.Mutation
    case "Piece": return ApolloGQL.Objects.Piece
    case "PieceConnection": return ApolloGQL.Objects.PieceConnection
    case "PieceEdge": return ApolloGQL.Objects.PieceEdge
    case "PieceInsertResponse": return ApolloGQL.Objects.PieceInsertResponse
    case "PieceUpdateResponse": return ApolloGQL.Objects.PieceUpdateResponse
    case "PracticeSessions": return ApolloGQL.Objects.PracticeSessions
    case "PracticeSessionsConnection": return ApolloGQL.Objects.PracticeSessionsConnection
    case "PracticeSessionsEdge": return ApolloGQL.Objects.PracticeSessionsEdge
    case "PracticeSessionsInsertResponse": return ApolloGQL.Objects.PracticeSessionsInsertResponse
    case "Query": return ApolloGQL.Objects.Query
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
