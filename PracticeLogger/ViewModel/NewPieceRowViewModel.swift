//
//  NewPieceRowViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/27/24.
//

import Foundation
import Combine

class NewPieceRowViewModel: ObservableObject {
    @Published var piece: Piece
    init(piece: Piece) {
        self.piece = piece
    }

    @MainActor
    func addMetadata(to piece: Piece) async throws -> Piece? {
        do {
            if let response: MetadataInformation = try await Database.client.rpc("parse_piece_metadata", params: ["work_name": piece.workName]).select().single().execute().value {

                let updatedPiece = piece
                updatedPiece.catalogue_number = response.catalogue_number
                updatedPiece.catalogue_type = response.catalogue_type
                updatedPiece.key_signature = response.key_signature
                updatedPiece.tonality = response.tonality
                updatedPiece.format = response.format
                updatedPiece.nickname = response.nickname

                self.piece = updatedPiece
                return updatedPiece
            }
            return nil
        } catch {
            print("Error getting piece information:", error)
            return nil
        }
    }
}
