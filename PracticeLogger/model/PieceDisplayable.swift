//
//  PieceDisplayable.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/14/25.
//
import ApolloAPI
import ApolloGQL
import Foundation

protocol PieceCompatible {
    // Basic identifiers
    var id: ApolloGQL.ID { get }
    var imslpPieceId: ApolloGQL.ID? { get }

    // Basic information (for display and edit)
    var workName: String { get }
    var nickname: String? { get }

    // Composer information
    var composerId: ApolloGQL.ID? { get }
    var composer: ComposerCompatible? { get }

    // Practice information
    var lastPracticed: ApolloGQL.Datetime? { get }
    var totalPracticeTime: Int? { get }

    // Catalog information
    var catalogueType: GraphQLEnum<CatalogueType>? { get }
    var catalogueNumber: Int? { get }
    var catalogueNumberSecondary: String? { get }
    var catalogueTypeNumDesc: String? { get }

    // Musical information
    var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { get }
    var format: GraphQLEnum<ApolloGQL.PieceFormat>? { get }
    var pieceStyle: String? { get }
    var subPieceType: String? { get }
    var subPieceCount: Int? { get }

    // Year information
    var compositionYear: Int? { get }
    var compositionYearDesc: String? { get }
    var compositionYearString: String? { get }

    // External links
    var wikipediaUrl: String? { get }
    var imslpUrl: String? { get }

    // Instrumentation
    var instrumentation: [String?]? { get }

    // Movements
    func getMovements() -> [MovementCompatible]
    func toEditableModel() -> EditablePieceModel
}

// Supporting protocol for composer
protocol ComposerCompatible {
    var id: ApolloGQL.ID? { get }
    var name: String { get }
}

// Movement connection protocol that matches GraphQL structure
protocol MovementConnection {
    var edges: [MovementEdge?]? { get }
}

protocol MovementEdge {
    var node: MovementCompatible? { get }
}

protocol MovementCompatible {
    var id: ApolloGQL.ID { get }
    var name: String { get }
    var number: Int? { get }
    var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { get }
    var nickname: String? { get }
    var lastPracticed: ApolloGQL.Datetime? { get }
    var totalPracticeTime: Int? { get }
    var downloadUrl: String? { get }
    var pieceId: ApolloGQL.ID? { get }

    func toEditableModel() -> EditableMovementModel
}

// Separate editable model classes for actual editing
class EditablePieceModel: ObservableObject {
    @Published var id: ApolloGQL.ID
    @Published var workName: String
    @Published var nickname: String?
    @Published var composer: EditableComposerModel?
    // All other editable fields
    @Published var movements: [EditableMovementModel]

    init(from pieceCompatible: PieceCompatible) {
        id = pieceCompatible.id
        workName = pieceCompatible.workName
        nickname = pieceCompatible.nickname
        // Initialize all other fields

        // Convert movements
        movements = pieceCompatible.getMovements()
    }

    // Method to create the mutation input for saving
    func toMutationInput() -> PieceInsertInput {
        // Logic to convert back to API input format
    }
}

class EditableComposerModel: ObservableObject {
    @Published var id: ApolloGQL.ID?
    @Published var name: String

    init(id: ApolloGQL.ID?, name: String) {
        self.id = id
        self.name = name
    }
}

class EditableMovementModel: ObservableObject, Identifiable {
    @Published var id: ApolloGQL.ID
    @Published var name: String
    @Published var number: Int?
    // Other editable movement properties

    init(from movement: MovementCompatible) {
        id = movement.id
        name = movement.name
        number = movement.number
        // Initialize other properties
    }
}
