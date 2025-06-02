//
//  Error.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/11/24.
//

import Foundation

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
