//
//  View.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/27/24.
//

import Foundation
import SwiftUI

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }

            return 0
        }

        return 0
    }
}
