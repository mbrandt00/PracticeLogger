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

        let keyboardDidShow = NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            .map { _ in true }

        let keyboardDidHide = NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)
            .map { _ in false }

        Publishers.MergeMany(keyboardWillShow, keyboardWillHide, keyboardDidShow, keyboardDidHide)
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
