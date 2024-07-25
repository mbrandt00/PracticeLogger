//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import MusicKit
import SwiftUI

struct ContentView: View {
    @Binding var isSignedIn: Bool
    @State private var selectedTab: Tabs = .start
    @Namespace private var animation
    @State private var isExpanded: Bool = false
    @StateObject var viewModel = PracticeSessionViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        if isSignedIn {
            if isExpanded {
                if let activeSession = viewModel.activeSession {
                    ExpandedBottomSheet(animation: animation, activeSession: activeSession, expandedSheet: $isExpanded)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            } else {
                VStack {
                    switch selectedTab {
                    case .progress:
                        ProgressView()
                    case .start:
                        CreatePiece()
                    case .profile:
                        Profile(isSignedIn: $isSignedIn)
                    }

                    Spacer()
                    if !keyboardResponder.isKeyboardVisible {
                        CustomTabBar(selectedTab: $selectedTab, expandedSheet: $isExpanded, animation: animation)
                            .ignoresSafeArea(.keyboard)
                    }
                }
                .environmentObject(viewModel)
                .animation(.easeInOut(duration: 0.9), value: keyboardResponder.isKeyboardVisible)
                .onAppear {
                    Task {
                        do {
                            viewModel.activeSession = await viewModel.fetchCurrentActiveSession()
                        }
                    }
                }
            }
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isSignedIn: .constant(true))
            .environmentObject(PracticeSessionManager())
    }
}
