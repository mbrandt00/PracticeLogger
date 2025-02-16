//
//  BottomSheetModifiers.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/16/25.
//

import SwiftUI

struct BottomSheetAware: ViewModifier {
    @EnvironmentObject var practiceSessionViewModel: PracticeSessionViewModel
    let geometry: GeometryProxy

    func body(content: Content) -> some View {
        content.padding(.bottom, practiceSessionViewModel.activeSession != nil ? 70 : 0)
    }
}

extension View {
    func bottomSheetAware(geometry: GeometryProxy) -> some View {
        modifier(BottomSheetAware(geometry: geometry))
    }
}
