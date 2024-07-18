//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @Binding var isSignedIn: Bool
    @EnvironmentObject var manager: PracticeSessionManager
    @State private var selectedTab: Tabs = .start
    @State private var isTyping: Bool = false
    @Namespace private var animation
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack {
            if isSignedIn {
                if isExpanded {
                    if let activeSession = manager.activeSession {
                        ExpandedBottomSheet(animation: animation, activeSession: activeSession, expandedSheet: $isExpanded)
                            .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                    } else {
                        Text("No active session")
                    }
                } else {
                    VStack {
                        switch selectedTab {
                        case .progress:
                            ProgressView()
                        case .start:
                            CreatePiece(isTyping: $isTyping)
                        case .profile:
                            Profile(isSignedIn: $isSignedIn).environmentObject(manager)
                        }

                        Spacer()
                        CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping, expandedSheet: $isExpanded, animation: animation).environmentObject(manager)
                    }
                }
            } else {
                SignIn(isSignedIn: $isSignedIn)
                    .onChange(of: isSignedIn) { newValue in
                        if newValue {
                            // Initialize manager or perform necessary actions upon sign-in
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isSignedIn: .constant(true))
            .environmentObject(PracticeSessionManager()) // Inject mock manager for preview
    }
}
