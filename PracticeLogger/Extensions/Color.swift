//
//  Color.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import Foundation
import SwiftUI
extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let blue = Color("BlueColor")
    let gray = Color("GrayColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
