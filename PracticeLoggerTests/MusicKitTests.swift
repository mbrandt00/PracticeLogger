//
//  MusicKitTests.swift
//  PracticeLoggerTests
//
//  Created by Michael Brandt on 3/9/24.
//

import XCTest
@testable import PracticeLogger
final class MusicKitTests: XCTestCase {
    func test_search_piece_from_song_name ()  async throws {
        let pieces = try await Piece.searchPieceFromSongName(query: "Rachmaninoff Piano concerto 2")
        XCTAssertGreaterThan(pieces.count, 1)
        XCTAssertEqual(pieces.first?.movements.first?.name, "Moderato")
        XCTAssertEqual(pieces.first?.composer?.name, "Sergei Rachmaninoff")
    }

    func test_song_matches_row () async throws {
        let pieces = try await Piece.searchPieceFromSongName(query: "Rachmaninoff Piano concerto 2")
    }

    func test_search_piece_with_key_signature ()  async throws {
        let pieces = try await Piece.searchPieceFromSongName(query: "Rachmaninoff Piano concerto D minor")
        XCTAssertGreaterThan(pieces.count, 1)
        XCTAssertEqual(pieces.first?.movements.first?.name, "Moderato")
        XCTAssertEqual(pieces.first?.composer?.name, "Sergei Rachmaninoff")
    }
    func test_search_search_less_popular_sonata ()  async throws {
        let pieces = try await Piece.searchPieceFromSongName(query: "Mozart Piano Sonata 5 G major")
        XCTAssertGreaterThan(pieces.count, 1)
        XCTAssertEqual(pieces.first?.movements.first?.name, "Moderato")
        XCTAssertEqual(pieces.first?.composer?.name, "Sergei Rachmaninoff")
    }

    func testFormatKeySignature() {
        XCTAssertEqual(Set(["b", "flat", "minor"]).formatKeySignature(), "B♭ Minor")
        XCTAssertEqual(Set(["c", "sharp", "minor"]).formatKeySignature(), "C♯ Minor")
        XCTAssertEqual(Set(["c", "major"]).formatKeySignature(), "C Major")
        XCTAssertEqual(Set(["d", "flat", "minor"]).formatKeySignature(), "D♭ Minor")
    }
}
