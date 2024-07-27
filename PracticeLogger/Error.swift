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
