//
//  GlobalToastManager.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/29/25.
//

import AlertToast
import SwiftUI

class GlobalToastManager: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var type: AlertToast.AlertType = .regular
    @Published var title: String? = nil
    @Published var subTitle: String? = nil
    @Published var displayMode: AlertToast.DisplayMode = .banner(.slide)

    func show(
        type: AlertToast.AlertType,
        title: String? = nil,
        subTitle: String? = nil,
        displayMode: AlertToast.DisplayMode = .banner(.slide)
    ) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.displayMode = displayMode
        self.isShowing = true
    }

    func clear() {
        self.isShowing = false
        self.title = nil
        self.subTitle = nil
        self.type = .regular
        self.displayMode = .banner(.slide)
    }
}
