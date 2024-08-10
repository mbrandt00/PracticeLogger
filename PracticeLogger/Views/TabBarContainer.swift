//
//  TabBarContainer.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/2/24.
//

import SwiftUI

struct TabBarContainer<Content: View>: View {
    @Binding var selectedTab: Tabs
    @Namespace private var animation

    @Binding var isExpanded: Bool
    @EnvironmentObject private var practiceSessionViewModel: PracticeSessionViewModel
    @EnvironmentObject private var keyboardResponder: KeyboardResponder
    let content: () -> Content

    var body: some View {
        if isExpanded, let activeSession = practiceSessionViewModel.activeSession {
            ExpandedBottomSheet(expandSheet: $isExpanded, activeSession: activeSession, animation: animation)
                .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))

        } else {
            VStack {
                content()

                Spacer()

                if !isExpanded && !keyboardResponder.isKeyboardVisible {
                    TabBar(selectedTab: $selectedTab, expandedSheet: $isExpanded, animation: animation)
                        .environmentObject(practiceSessionViewModel)
                        .animation(.easeInOut(duration: 0.9), value: keyboardResponder.isKeyboardVisible)
                        .onAppear {
                            Task {
                                do {
                                    practiceSessionViewModel.activeSession = await practiceSessionViewModel.fetchCurrentActiveSession()
                                }
                            }
                        }
                }
            }
        }
    }
}

struct TabBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContainer(
            selectedTab: .constant(.start),
            isExpanded: .constant(false),
            content: {
                ProgressView()
            }
        )
        .environmentObject(PracticeSessionViewModel())
        .environmentObject(KeyboardResponder())
    }
}
