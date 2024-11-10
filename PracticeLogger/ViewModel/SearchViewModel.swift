//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import ApolloGQL
import Combine
import Foundation
import MusicKit

class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var isFocused: Bool = false
    @Published var selectedKeySignature: KeySignatureType?
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [Piece] = []
    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func searchPieces() async {
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    userPieces = try await getUserPieces()
                    if !searchTerm.isEmpty {
                        var fetchedPieces = try await Piece.searchPieceFromSongName(query: searchTerm)
//                        let userPieceSet = Set(userPieces)
//                        fetchedPieces.removeAll { userPieceSet.contains($0) }
                        if let selectedKeySignature = selectedKeySignature {
                            fetchedPieces = fetchedPieces.filter { $0.key_signature == selectedKeySignature }
                        }
//                        userPieces = userPieces
                        newPieces = fetchedPieces
                    }
                } catch {
                    print("Error fetching pieces: \(error)")
                }
            default:
                print("Unknown music authorization status.")
            }
        }
    }

    func getUserPieces() async throws -> [PieceDetails] {
        let userId = try await Database.client.auth.user().id.uuidString

        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: searchTerm, pieceFilter: .some(PiecesFilter(userId: .some(UUIDFilter(eq: .some(userId))))))) { result in
                switch result {
                case .success(let graphQlResult):
                    if let pieces = graphQlResult.data?.searchPieceWithAssociations?.edges {
                        let nodes = pieces.compactMap { $0.node.fragments.pieceDetails }
                        continuation.resume(returning: nodes)
                    } else {
                        continuation.resume(returning: [])
                    }
                case .failure(let error):
                    print("GraphQL query failed: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }

//    func addKeySignatureToken(_ keySignature: KeySignatureType) {
//        // Remove any existing tokens of type keySignature
//        tokens.removeAll {
//            if case .keySignature = $0.filterType {
//                return true
//            }
//            return false
//        }
//
//        // Add the new token
//        let newToken = FilterToken(filterType: .keySignature(keySignature))
//        tokens.append(newToken)
//    }

//    func removeKeySignatureToken() {
//        tokens.removeAll {
//            if case .keySignature = $0.filterType {
//                return true
//            }
//            return false
//        }
//    }
}

// struct KeySignatureToken: Identifiable, Hashable {
//    var id: UUID = .init()
//    var type: KeySignatureType?
//    var tonality: KeySignatureTonality?
//
//    var displayText: String {
//        if let type = type, let tonality = tonality {
//            return "\(type.rawValue) \(tonality.rawValue)"
//        } else if let type = type {
//            return type.rawValue
//        } else if let tonality = tonality {
//            return tonality.rawValue
//        } else {
//            return ""
//        }
//    }
//
//    mutating func updateTonality(_ newTonality: KeySignatureTonality) {
//        tonality = newTonality
//    }
//
//    static func from(type: KeySignatureType?, tonality: KeySignatureTonality?) -> KeySignatureToken? {
//        if let type = type {
//            if let tonality = tonality {
//                return KeySignatureToken(type: type, tonality: tonality)
//            } else {
//                return KeySignatureToken(type: type, tonality: nil)
//            }
//        } else if let tonality = tonality {
//            return KeySignatureToken(type: nil, tonality: tonality)
//        } else {
//            return nil
//        }
//    }
// }

// struct FilterToken: Identifiable {
//    var id: UUID = .init()
//    var filterType: FilterType
//    func displayText() -> String {
//        switch filterType {
//        case .keySignature(let keySignatureType):
//            return keySignatureType.rawValue
//        case .composer(let composer):
//            return composer.name
//        case .tonality(let tonality):
//            return tonality.rawValue
//        }
//    }
// }
//
// enum FilterType {
//    case keySignature(KeySignatureType)
//    case composer(Composer)
//    case tonality(KeySignatureTonality)
// }
