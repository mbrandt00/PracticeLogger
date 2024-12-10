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
    
    func insertPiece() async throws -> PieceDetails {
        // Will implement this later when needed
        print(editablePiece)
        fatalError("Not implemented")
    }
    
    func move(from source: IndexSet, to destination: Int) {
        guard var movements = editablePiece.movements else { return }
        movements.move(fromOffsets: source, toOffset: destination)
        for (index, movement) in movements.enumerated() {
            movement.number = index + 1
        }
        editablePiece.movements = movements
    }
    
    func updateMovementName(at index: Int, newName: String) {
        guard let movements = editablePiece.movements,
              index < movements.count else { return }
        editablePiece.movements?[index].name = newName
    }
    
    func isDuplicate() async throws -> PieceDetails? {
        guard let catalogueNumber = editablePiece.catalogueNumber,
              let catalogueType = editablePiece.catalogueType else {
            return nil
        }
        // Will implement later when needed
        return nil
    }
}

class EditablePiece: ObservableObject {
    let id: ApolloGQL.BigInt
    @Published var workName: String
    @Published var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>?
    @Published var catalogueNumber: Int?
    @Published var nickname: String?
    @Published var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?
    @Published var format: GraphQLEnum<PieceFormat>?
    @Published var movements: [EditableMovement]?
    @Published var composer: EditableComposer?
    @Published var compositionYear: Int?
    @Published var imslpUrl: String?
    @Published var wikipediaUrl: String?
    @Published var instrumentation:  [String?]?
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
        self.movements = piece.movements?.edges.map { EditableMovement(from: $0.node) }
        if let composer = piece.composer {
            self.composer = EditableComposer(from: composer)
        }
    }
    
    func toGraphQLInput() -> PiecesInsertInput {
        PiecesInsertInput(
            nickname: .some(self.nickname ?? ""),
            keySignature: self.keySignature != nil ? .some(self.keySignature!) : .none,
            catalogueType: self.catalogueType != nil ? .some(self.catalogueType!) : .none,
            catalogueNumber: self.catalogueNumber != nil ? .some(self.catalogueNumber!) : .none
        )
    }
}

class EditableMovement {
    let id: ApolloGQL.BigInt
    var name: String?
    var number: Int?
    
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
