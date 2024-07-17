//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @State var selectedTab: Tabs = .start
    @State var isTyping: Bool = false
    @State var isSignedIn: Bool = false
    @State var isExpanded: Bool = false
    @State var practiceSessionManager: PracticeSessionManager?
    @Namespace private var animation

    var body: some View {
        VStack {
            if isSignedIn {
                if let manager = practiceSessionManager {
                    if isExpanded && manager.activeSession != nil {
                        ExpandedBottomSheet(animation: animation, activeSession: manager.activeSession!, expandedSheet: $isExpanded)
                            .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                    } else {
                        VStack {
                            switch selectedTab {
                            case .progress:
                                ProgressView()
                            case .start:
                                CreatePiece(isTyping: $isTyping)
                            case .profile:
                                Profile(isSignedIn: $isSignedIn) .environmentObject(manager)
                            }

                            Spacer()
                            CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping, expandedSheet: $isExpanded, animation: animation).environmentObject(manager)
                        }
                    }
                }
            } else {
                SignIn(isSignedIn: $isSignedIn)
                    .onChange(of: isSignedIn) { newValue in
                        if newValue {
                            practiceSessionManager = PracticeSessionManager()
                        }
                    }
            }
        }
        .onAppear {
            Task {
                do {
                    practiceSessionManager = PracticeSessionManager()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentView() // .navigationBarHidden(true)
    }
}
