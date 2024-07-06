//
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
    @State var practiceSessionManager: PracticeSessionManager?

    let bpm: Double = 60

    var body: some View {
        VStack {
            if isSignedIn {
                if let manager = practiceSessionManager {
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
                        CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping)
                    }
                } else {
                    // This case is just to handle the moment right after login before the manager is set
                    ProgressView("Loading...")
                        .onAppear {
                            practiceSessionManager = PracticeSessionManager()
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
    }
}

#Preview {
    NavigationView {
        ContentView() // .navigationBarHidden(true)
    }
}
