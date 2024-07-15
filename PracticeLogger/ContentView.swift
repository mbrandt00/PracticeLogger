//
    //  ContentView.swift
    //  PracticeLogger
    //
    //  Created by Michael Brandt on 2/23/24.
    //

import SwiftUI
import MusicKit

struct ContentView: View {
    @State private var selectedTab: Tabs = .start
    @State private var isTyping: Bool = false
    @State private var isSignedIn: Bool = false
    @State private var isExpanded: Bool = false
    @State private var practiceSessionManager: PracticeSessionManager?
    @Namespace private var animation

    let bpm: Double = 60

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
                                ProgressView().environmentObject(manager)
                            case .start:
                                CreatePiece(isTyping: $isTyping).environmentObject(manager)
                            case .profile:
                                Profile(isSignedIn: $isSignedIn).environmentObject(manager)
                            }

                            Spacer()
                            CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping, expandedSheet: $isExpanded, animation: animation).environmentObject(manager)
                        }
                    }
                } else {
                    ProgressView("Loading...")
                        .onAppear {
                            initializePracticeSessionManager()
                        }
                }
            } else {
                SignIn(isSignedIn: $isSignedIn)
                    .onChange(of: isSignedIn) { newValue in
                        if newValue {
                            initializePracticeSessionManager()
                        }
                    }
            }
        }
        .onAppear {
            checkSupabaseSession()
        }
    }

    private func checkSupabaseSession() {
        Task {
            do {
                _ = try await Database.getCurrentUser()
                isSignedIn = true
                initializePracticeSessionManager()
            } catch {
                isSignedIn = false
                debugPrint(error)
            }
        }
    }

    private func initializePracticeSessionManager() {
        self.practiceSessionManager = PracticeSessionManager()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
