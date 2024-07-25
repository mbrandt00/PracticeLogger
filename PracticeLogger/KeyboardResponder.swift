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
            .handleEvents(receiveOutput: { _ in
                print("Keyboard will show")
            })

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }

        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}
