//
//  String.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/30/24.
//

import Foundation

extension String {
    func isNumber() -> Bool {
        return Double(self) != nil
    }
}
