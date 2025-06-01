//
//  MockPracticeSessions.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/27/25.
//

import ApolloGQL
import Foundation

extension PracticeSessionDetails.Piece {
    init(from details: PieceDetails) {
        self.init(
            lastPracticed: details.lastPracticed,
            totalPracticeTime: details.totalPracticeTime,
            id: details.id,
            workName: details.workName,
            catalogueType: details.catalogueType,
            keySignature: details.keySignature,
            format: details.format,
            instrumentation: details.instrumentation,
            wikipediaUrl: details.wikipediaUrl,
            imslpUrl: details.imslpUrl,
            compositionYear: details.compositionYear,
            catalogueNumberSecondary: details.catalogueNumberSecondary,
            catalogueTypeNumDesc: details.catalogueTypeNumDesc,
            compositionYearDesc: details.compositionYearDesc,
            compositionYearString: details.compositionYearString,
            pieceStyle: details.pieceStyle,
            subPieceType: details.subPieceType,
            subPieceCount: details.subPieceCount,
            userId: details.userId,
            collectionId: details.collectionId,
            collection: details.collection,
            catalogueNumber: details.catalogueNumber,
            nickname: details.nickname,
            composerId: details.composerId,
            composer: details.composer,
            movements: details.movements
        )
    }
}

extension PracticeSessionDetails {
    static let previewBach = PracticeSessionDetails(
        id: BigInt(1001),
        startTime: Date().addingTimeInterval(-600), // 10 minutes ago
        movement: PracticeSessionDetails.Movement(
            id: BigInt(4),
            name: "Prelude",
            number: 1
        ),
        piece: .init(from: PieceDetails.previewBach)
    )

    static let previewChopin = PracticeSessionDetails(
        id: BigInt(1002),
        startTime: Date().addingTimeInterval(-1800), // 30 minutes ago
        movement: PracticeSessionDetails.Movement(
            id: BigInt(5),
            name: "Nocturne in F minor",
            number: 2
        ),
        piece: .init(from: PieceDetails.previewChopin)
    )

    static let previewBeethoven = PracticeSessionDetails(
        id: BigInt(1003),
        startTime: Date().addingTimeInterval(-3600), // 1 hour ago
        movement: PracticeSessionDetails.Movement(
            id: BigInt(11),
            name: "Scherzo: Assai vivace",
            number: 2
        ),
        piece: .init(from: PieceDetails.previewBeethoven)
    )

    static let previewChopinNoMovement = PracticeSessionDetails(
        id: BigInt(1004),
        startTime: Date().addingTimeInterval(-90), // 1.5 minutes ago
        movement: nil,
        piece: .init(from: PieceDetails.previewChopin)
    )

    static let previewBachFinalMovement = PracticeSessionDetails(
        id: BigInt(1005),
        startTime: Date().addingTimeInterval(-150), // 2.5 minutes ago
        movement: PracticeSessionDetails.Movement(
            id: BigInt(6),
            name: "Courante",
            number: 3
        ),
        piece: .init(from: PieceDetails.previewBach)
    )

    static let allPreviews = [
        previewBach,
        previewChopin,
        previewBeethoven,
        previewChopinNoMovement,
        previewBachFinalMovement
    ]
}
