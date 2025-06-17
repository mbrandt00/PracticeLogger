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
        editablePiece = EditablePiece(from: piece)
    }

    func insertPiece() async throws -> PieceDetails {
        let manager = PieceDbUpdater(piece: editablePiece)

        return try await manager.save()
    }

    func updatePiece() async throws -> PieceDetails {
        let updater = PieceDbUpdater(pieceId: editablePiece.id, piece: editablePiece)

        return try await updater.save()
    }

    func fetchComposers() async throws -> [EditableComposer] {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: ComposersQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
                switch result {
                case let .success(response):
                    let composers: [EditableComposer] = response.data?.composersCollection?.edges.compactMap { edge in
                        let composer = edge.node
                        return EditableComposer(firstName: composer.firstName, lastName: composer.lastName, id: composer.id)
                    } ?? []

                    continuation.resume(returning: composers)

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func updateMovement(at index: Int, newName: String) {
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
    @Published var collectionId: ApolloGQL.BigInt?
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
        id = piece.id
        workName = piece.workName
        catalogueType = piece.catalogueType
        catalogueNumber = piece.catalogueNumber
        nickname = piece.nickname
        collectionId = piece.collectionId
        keySignature = piece.keySignature
        instrumentation = piece.instrumentation
        subPieceType = piece.subPieceType
        format = piece.format
        compositionYear = piece.compositionYear
        wikipediaUrl = piece.wikipediaUrl
        imslpUrl = piece.imslpUrl
        lastPracticed = piece.lastPracticed
        totalPracticeTime = piece.totalPracticeTime

        if let movements = piece.movements?.edges {
            self.movements = movements.compactMap { edge in
                EditableMovement(from: edge.node)
            }.sorted { ($0.number ?? 0) < ($1.number ?? 0) }
        }

        if let composer = piece.composer {
            self.composer = EditableComposer(from: composer)
            composerId = composer.id
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
        id = node.id
        name = node.name
        number = node.number
        pieceId = node.pieceId
        keySignature = node.keySignature
        downloadUrl = node.downloadUrl
        nickname = node.nickname
        lastPracticed = node.lastPracticed
        totalPracticeTime = node.totalPracticeTime
    }

    static func == (lhs: EditableMovement, rhs: EditableMovement) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.keySignature == rhs.keySignature && lhs.number == rhs.number
    }
}

class EditableComposer: Equatable, Hashable, Identifiable {
    var firstName: String
    var lastName: String
    var id: ApolloGQL.BigInt?

    init(from composer: PieceDetails.Composer) {
        firstName = composer.firstName
        lastName = composer.lastName
        id = composer.id
    }

    init(firstName: String, lastName: String, id: ApolloGQL.BigInt? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }

    static func == (lhs: EditableComposer, rhs: EditableComposer) -> Bool {
        lhs.id == rhs.id || (lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
    }
}

extension EditablePiece {
    func toGraphQLInput() async throws -> PieceInsertInput {
        try PieceInsertInput(
            workName: .some(workName),
            composerId: composerId.map { .some($0) } ?? .null,
            nickname: nickname.map { .some($0) } ?? .null,
            userId: .some(await Database.client.auth.user().id.uuidString),
            format: format.map { .some($0) } ?? .null,
            keySignature: keySignature.map { .some($0) } ?? .null,
            catalogueType: catalogueType.map { .some($0) } ?? .null,
            catalogueNumber: catalogueNumber.map { .some($0) } ?? .null,
            catalogueNumberSecondary: catalogueNumberSecondary.map { .some($0) } ?? .null,
            compositionYear: compositionYear.map { .some($0) } ?? .null,
            wikipediaUrl: wikipediaUrl.map { .some($0) } ?? .null,
            instrumentation: instrumentation.map { .some($0) } ?? .null,
            subPieceType: subPieceType.map { .some($0) } ?? .null,
            imslpUrl: imslpUrl.map { .some($0) } ?? .null,
            collectionId: collectionId.map { .some($0) } ?? .null
        )
    }

    func toGraphQLUpdateInput() -> PieceUpdateInput {
        return PieceUpdateInput(
            workName: .some(workName),
            composerId: composerId != nil ? .some(composerId!) : .null,
            nickname: nickname != nil ? .some(nickname!) : .null,
            format: format != nil ? .some(format!) : .null,
            keySignature: keySignature != nil ? .some(keySignature!) : .null,
            catalogueType: catalogueType != nil ? .some(catalogueType!) : .null,
            catalogueNumber: catalogueNumber != nil ? .some(catalogueNumber!) : .null,
            catalogueTypeNumDesc: catalogueTypeNumDesc != nil ? .some(catalogueTypeNumDesc!) : .null,
            catalogueNumberSecondary: catalogueNumberSecondary != nil ? .some(catalogueNumberSecondary!) : .null,
            compositionYear: compositionYear != nil ? .some(compositionYear!) : .null,
            compositionYearDesc: compositionYearDesc != nil ? .some(compositionYearDesc!) : .null,
            pieceStyle: pieceStyle != nil ? .some(pieceStyle!) : .null,
            wikipediaUrl: wikipediaUrl != nil ? .some(wikipediaUrl!) : .null,
            instrumentation: instrumentation != nil ? .some(instrumentation!) : .null,
            compositionYearString: compositionYearString != nil ? .some(compositionYearString!) : .null,
            subPieceType: subPieceType != nil ? .some(subPieceType!) : .null,
            subPieceCount: subPieceCount != nil ? .some(subPieceCount!) : .null,
            imslpUrl: imslpUrl != nil ? .some(imslpUrl!) : .null
        )
    }
}
