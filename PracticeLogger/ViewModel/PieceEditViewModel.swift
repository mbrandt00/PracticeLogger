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

    // Constructor for PieceDetails
    init(piece: PieceDetails) {
        self.editablePiece = EditablePiece(from: piece)
    }

    func insertPiece() async throws -> PieceDetails {
        let manager = PieceDbUpdater(piece: editablePiece)

        return try await manager.save()
    }

    func updatePiece() async throws -> PieceDetails {
        let updater = PieceDbUpdater(pieceId: editablePiece.id, piece: self.editablePiece)

        return try await updater.save()
    }

    func updateMovement(at index: Int, newName: String) {
        let movements = self.editablePiece.movements

        // Update directly on the existing array
        self.editablePiece.movements[index].name = newName

        // Force a view update by reassigning the array
        let updatedMovements = self.editablePiece.movements
        self.editablePiece.movements = updatedMovements
    }

    func deleteMovement(at index: Int) {
        var movements = self.editablePiece.movements

        movements.remove(at: index)

        // Update numbering
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }
        self.editablePiece.movements = movements
    }

    func moveMovements(from source: IndexSet, to destination: Int) {
        var movements = self.editablePiece.movements
        movements.move(fromOffsets: source, toOffset: destination)

        // Update numbering
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }

        self.editablePiece.movements = movements
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
    @Published var catalogueTypeNumDesc: String?
    @Published var imslpUrl: String?
    @Published var compositionYearDesc: String?
    @Published var wikipediaUrl: String?
    @Published var instrumentation: [String?]?
    @Published var catalogueNumberSecondary: Int?
    @Published var subPieceCount: Int?
    @Published var compositionYearString: String?
    @Published var lastPlayed: Date?
    @Published var pieceStyle: String?
    @Published var lastPracticed: Date?
    @Published var totalPracticeTime: Int?
    @Published var imslpPieceId: ApolloGQL.BigInt?

    // Constructor for PieceDetails
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
        self.composerId = piece.composerId
        self.wikipediaUrl = piece.wikipediaUrl
        self.imslpUrl = piece.imslpUrl
        self.lastPracticed = piece.lastPracticed
        self.totalPracticeTime = piece.totalPracticeTime

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

class EditableMovement: Identifiable, ObservableObject, Equatable {
    @Published var id: ApolloGQL.BigInt
    @Published var name: String?
    @Published var number: Int?
    @Published var pieceId: String?
    @Published var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?
    @Published var downloadUrl: String?
    @Published var nickname: String?
    @Published var lastPracticed: Date?
    @Published var totalPracticeTime: Int?

    // Constructor for PieceDetails movement
    init(from node: PieceDetails.Movements.Edge.Node) {
        self.id = node.id
        self.name = node.name
        self.number = node.number
        self.pieceId = node.pieceId
        self.keySignature = node.keySignature
        self.downloadUrl = node.downloadUrl
        self.nickname = node.nickname
        self.lastPracticed = node.lastPracticed
        self.totalPracticeTime = node.totalPracticeTime
    }

    static func == (lhs: EditableMovement, rhs: EditableMovement) -> Bool {
        return lhs.id == rhs.id
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

extension EditablePiece {
    func toGraphQLInput() async throws -> PieceInsertInput {
        try PieceInsertInput(
            workName: .some(self.workName),
            composerId: self.composerId.map { .some($0) } ?? .null,
            nickname: self.nickname.map { .some($0) } ?? .null,
            userId: .some(await Database.client.auth.user().id.uuidString),
            format: self.format.map { .some($0) } ?? .null,
            keySignature: self.keySignature.map { .some($0) } ?? .null,
            catalogueType: self.catalogueType.map { .some($0) } ?? .null,
            catalogueNumber: self.catalogueNumber.map { .some($0) } ?? .null,
            compositionYear: self.compositionYear.map { .some($0) } ?? .null,
            wikipediaUrl: self.wikipediaUrl.map { .some($0) } ?? .null,
            instrumentation: self.instrumentation.map { .some($0) } ?? .null,
            subPieceType: self.subPieceType.map { .some($0) } ?? .null,
            imslpUrl: self.imslpUrl.map { .some($0) } ?? .null,
            isImslp: false
        )
    }

    func toGraphQLUpdateInput() -> PieceUpdateInput {
        return PieceUpdateInput(
            workName: self.workName != nil ? .some(self.workName) : .null,
            composerId: self.composerId != nil ? .some(self.composerId!) : .null,
            nickname: self.nickname != nil ? .some(self.nickname!) : .null,
            format: self.format != nil ? .some(self.format!) : .null,
            keySignature: self.keySignature != nil ? .some(self.keySignature!) : .null,
            catalogueType: self.catalogueType != nil ? .some(self.catalogueType!) : .null,
            catalogueNumber: self.catalogueNumber != nil ? .some(self.catalogueNumber!) : .null,
            catalogueTypeNumDesc: self.catalogueTypeNumDesc != nil ? .some(self.catalogueTypeNumDesc!) : .null,
            catalogueNumberSecondary: self.catalogueNumberSecondary != nil ? .some(self.catalogueNumberSecondary!) : .null,
            compositionYear: self.compositionYear != nil ? .some(self.compositionYear!) : .null,
            compositionYearDesc: self.compositionYearDesc != nil ? .some(self.compositionYearDesc!) : .null,
            pieceStyle: self.pieceStyle != nil ? .some(self.pieceStyle!) : .null,
            wikipediaUrl: self.wikipediaUrl != nil ? .some(self.wikipediaUrl!) : .null,
            instrumentation: self.instrumentation != nil ? .some(self.instrumentation!) : .null,
            compositionYearString: self.compositionYearString != nil ? .some(self.compositionYearString!) : .null,
            subPieceType: self.subPieceType != nil ? .some(self.subPieceType!) : .null,
            subPieceCount: self.subPieceCount != nil ? .some(self.subPieceCount!) : .null,
            imslpUrl: self.imslpUrl != nil ? .some(self.imslpUrl!) : .null
        )
    }
}
