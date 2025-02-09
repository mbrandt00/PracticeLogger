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
    @Published var selectedPiece: PieceDetails? = nil

    init(piece: ImslpPieceDetails) {
        self.editablePiece = EditablePiece(from: piece)
    }

    func insertPiece() async throws -> PieceDetails {
        let inserter = PieceInserter(piece: editablePiece)
        return try await inserter.insert()
    }

    func updateMovement(at index: Int, newName: String) {
        let movements = editablePiece.movements

        // Update directly on the existing array
        editablePiece.movements[index].name = newName

        // Force a view update by reassigning the array
        let updatedMovements = editablePiece.movements
        editablePiece.movements = updatedMovements
    }

    func deleteMovement(at index: Int) {
        var movements = editablePiece.movements

        movements.remove(at: index)

        // Update numbering
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }
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
    @Published var subPieceType: String?
    @Published var format: GraphQLEnum<PieceFormat>?
    @Published var movements: [EditableMovement] = []
    @Published var composer: EditableComposer?
    @Published var composerId: ApolloGQL.BigInt?
    @Published var compositionYear: Int?
    @Published var imslpUrl: String?
    @Published var wikipediaUrl: String?
    @Published var instrumentation: [String?]?

    init(from piece: ImslpPieceDetails) {
        self.id = piece.id
        self.workName = piece.workName
        self.catalogueType = piece.catalogueType
        self.catalogueNumber = piece.catalogueNumber
        self.nickname = piece.nickname
        self.keySignature = piece.keySignature
        self.instrumentation = piece.instrumentation
        self.format = piece.format
        self.compositionYear = piece.compositionYear
        self.composerId = piece.composerId
        self.wikipediaUrl = piece.wikipediaUrl
        self.imslpUrl = piece.imslpUrl
        if let movements = piece.movements?.edges {
            self.movements = movements.compactMap { edge in
                EditableMovement(from: edge.node)
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
    @Published var pieceId: String?

    init(from node: ImslpPieceDetails.Movements.Edge.Node) {
        self.id = node.id
        self.name = node.name
        self.number = node.number
        self.pieceId = node.pieceId
    }
}

extension EditableMovement {
    func toGraphQLInput() -> MovementInsertInput {
        MovementInsertInput(
            //            pieceId: .some(pieceId ?? ""),
            name: name.map { .some($0) } ?? .null,
            number: .some(number ?? 0)
        )
    }
}

class EditableComposer {
    var name: String
    var id: ApolloGQL.BigInt?

    init(from composer: ImslpPieceDetails.Composer) {
        self.name = composer.name
    }

    init(name: String) {
        self.name = name
    }
}

extension EditablePiece {
    func toGraphQLInput() -> PieceInsertInput {
        PieceInsertInput(
            workName: .some(workName),
            composerId: composerId.map { .some($0) } ?? .null,
            nickname: nickname.map { .some($0) } ?? .null,
            format: format.map { .some($0) } ?? .null,
            keySignature: keySignature.map { .some($0) } ?? .null,
            catalogueType: catalogueType.map { .some($0) } ?? .null,
            catalogueNumber: catalogueNumber.map { .some($0) } ?? .null,
            compositionYear: compositionYear.map { .some($0) } ?? .null,
            wikipediaUrl: wikipediaUrl.map { .some($0) } ?? .null,
            instrumentation: instrumentation.map { .some($0) } ?? .null,
            subPieceType: subPieceType.map { .some($0) } ?? .null, // make picker
            imslpUrl: imslpUrl.map { .some($0) } ?? .null,
            imslpPieceId: .some(id)
        )
    }
}
