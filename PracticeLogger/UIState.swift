//
//  UIState.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/6/25.
//

import Combine
import SwiftUI

class UIState: ObservableObject {
    /// Set to true when a UI element (like search) is active
    /// and should suppress other overlays like the BottomSheet.
    @Published var isScreenBusy: Bool = false
}
