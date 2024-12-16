//
//  PieceEditViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/28/24.
//

import ApolloAPI
import ApolloGQL
import Foundation
import Supabase
class PieceEditViewModel: ObservableObject {
    @Published var editablePiece: EditablePiece
    
    init(piece: PieceDetails) {
        self.editablePiece = EditablePiece(from: piece)
    }
    
    func insertPiece() throws -> Void {
        fatalError("Not implemented")
    }
    
    func updateMovement(at index: Int, newName: String) {
        print("⚡️ Updating movement at index: \(index)")
        let movements = editablePiece.movements
        
        
        // Update directly on the existing array
        editablePiece.movements[index].name = newName
        
        // Force a view update by reassigning the array
        let updatedMovements = editablePiece.movements
        editablePiece.movements = updatedMovements
        
        print("✅ Movement updated successfully")
    }
    
    func deleteMovement(at index: Int) {
        print("Deleting movement at index:", index)
        var movements = editablePiece.movements
        
        movements.remove(at: index)
        
        // Update numbering
        print("Updating numbers for remaining movements")
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }
        
        print("Final movements count:", movements.count)
        editablePiece.movements = movements
    }
    
    func moveMovements(from source: IndexSet, to destination: Int) {
        var movements = editablePiece.movements 
        movements.move(fromOffsets: source, toOffset: destination)
        
        // Update numbering
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }
        
        editablePiece.movements = movements
    }
}

class EditablePiece: ObservableObject {
    @Published var id: ApolloGQL.BigInt
    @Published var workName: String
    @Published var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>?
    @Published var catalogueNumber: Int?
    @Published var nickname: String?
    @Published var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?
    @Published var format: GraphQLEnum<PieceFormat>?
    @Published var movements: [EditableMovement]  = []
    @Published var composer: EditableComposer?
    @Published var compositionYear: Int?
    @Published var imslpUrl: String?
    @Published var wikipediaUrl: String?
    @Published var instrumentation: [String?]?
    
    init(from piece: PieceDetails) {
        self.id = piece.id
        self.workName = piece.workName
        self.catalogueType = piece.catalogueType
        self.catalogueNumber = piece.catalogueNumber
        self.nickname = piece.nickname
        self.keySignature = piece.keySignature
        self.instrumentation = piece.instrumentation
        self.format = piece.format
        self.compositionYear = piece.compositionYear
        self.wikipediaUrl = piece.wikipediaUrl
        self.imslpUrl = piece.imslpUrl
        if let movements = piece.movements?.edges {
            self.movements = movements.compactMap { edge in
                return EditableMovement(from: edge.node)
            }.sorted { ($0.number ?? 0) < ($1.number ?? 0) }
        }
        
        if let composer = piece.composer {
            self.composer = EditableComposer(from: composer)
        }
    }
}

class EditableMovement: Identifiable, ObservableObject {
    @Published var id: ApolloGQL.BigInt
    @Published var name: String?
    @Published var number: Int?
    
    init(from node: PieceDetails.Movements.Edge.Node) {
        self.id = node.id
        self.name = node.name
        self.number = node.number
    }
}

class EditableComposer {
    var name: String
    var id: ApolloGQL.BigInt?
    
    init(from composer: PieceDetails.Composer) {
        self.name = composer.name
    }
    
    init(name: String) {
        self.name = name
    }
}
