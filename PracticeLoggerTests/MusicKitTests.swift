//
//  MusicKitTests.swift
//  PracticeLoggerTests
//
//  Created by Michael Brandt on 3/9/24.
//

import XCTest
@testable import PracticeLogger
final class MusicKitTests: XCTestCase {
    func test_get_classical_pieces () async throws {
        let piece = try await Piece.searchPiece(query: "Rachmaninoff Piano concerto 2")
        XCTAssertEqual(piece.movements.count, 3)
        XCTAssertEqual(piece.movements.first?.name, "Moderato")
        XCTAssertEqual(piece.composer.name, "Sergei Rachmaninoff")
    }

}
