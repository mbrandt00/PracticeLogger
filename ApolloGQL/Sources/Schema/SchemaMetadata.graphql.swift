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
    case "Composers": return ApolloGQL.Objects.Composers
    case "ImslpMovement": return ApolloGQL.Objects.ImslpMovement
    case "ImslpMovementConnection": return ApolloGQL.Objects.ImslpMovementConnection
    case "ImslpMovementEdge": return ApolloGQL.Objects.ImslpMovementEdge
    case "ImslpPiece": return ApolloGQL.Objects.ImslpPiece
    case "ImslpPieceConnection": return ApolloGQL.Objects.ImslpPieceConnection
    case "ImslpPieceEdge": return ApolloGQL.Objects.ImslpPieceEdge
    case "Movement": return ApolloGQL.Objects.Movement
    case "MovementConnection": return ApolloGQL.Objects.MovementConnection
    case "MovementEdge": return ApolloGQL.Objects.MovementEdge
    case "MovementInsertResponse": return ApolloGQL.Objects.MovementInsertResponse
    case "Mutation": return ApolloGQL.Objects.Mutation
    case "Piece": return ApolloGQL.Objects.Piece
    case "PieceConnection": return ApolloGQL.Objects.PieceConnection
    case "PieceEdge": return ApolloGQL.Objects.PieceEdge
    case "PieceInsertResponse": return ApolloGQL.Objects.PieceInsertResponse
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
