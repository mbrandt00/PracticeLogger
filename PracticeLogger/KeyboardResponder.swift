//
//  KeyboardResponder.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/20/24.
//

import Combine
import Foundation
import SwiftUI

final class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }

        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }

    // Method to manually set keyboard visibility
    func setKeyboardVisible(_ isVisible: Bool) {
        DispatchQueue.main.async {
            self.isKeyboardVisible = isVisible
        }
    }
}
