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
            if isExpanded, let activeSession = viewModel.activeSession {
                ExpandedBottomSheet(animation: animation, activeSession: activeSession, expandedSheet: $isExpanded)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            } else {
                TabView(selection: $selectedTab) {
                    ProgressView()
                        .tabItem {
                            Image(systemName: "chart.xyaxis.line")
                            Text("Progress")
                        }
                        .tag(Tabs.progress)

                    CreatePiece()
                        .tabItem {
                            Image(systemName: "metronome")
                            Text("Practice")
                        }
                        .tag(Tabs.start)

                    Profile(isSignedIn: $isSignedIn)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(Tabs.profile)
                }
                .environmentObject(viewModel)
                .onAppear {
                    Task {
                        do {
                            viewModel.activeSession = await viewModel.fetchCurrentActiveSession()
                        }
                    }
                }
                .safeAreaInset(edge: .bottom, spacing: 100.0) {
                    if !keyboardResponder.isKeyboardVisible {
                        if let activeSession = viewModel.activeSession {
                            BottomSheet(animation: animation, isExpanded: $isExpanded, activeSession: activeSession)
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom).combined(with: .opacity)))
                                .animation(.easeInOut(duration: 0.3))
                                .environmentObject(viewModel)
                                .frame(maxHeight: 100)
                        }
                    }
                }
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                .toolbar(isExpanded ? .hidden : .visible, for: .tabBar)
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
