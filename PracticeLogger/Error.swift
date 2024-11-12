//
//  Error.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/11/24.
//

import Foundation

enum SupabaseError: Error {
    case pieceAlreadyExists
}

enum AuthError: Error {
    case notSignedIn, signInAppleNotEnabled
}

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
