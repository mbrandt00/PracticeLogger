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
    @StateObject var practiceSessionViewModel = PracticeSessionViewModel()
    @StateObject var searchViewModel = SearchViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()
    @State private var recentSessions: [PracticeSession] = []

    var body: some View {
        if isSignedIn {
            TabBarContainer(selectedTab: $selectedTab, isExpanded: $isExpanded) {
                SearchableContainer { searchViewModel in
                    VStack {
                        if searchViewModel.searchTerm.isEmpty {
                            VStack {
                                switch selectedTab {
                                case .progress:
                                    ProgressView()
                                case .start:
                                    List(recentSessions) { session in
                                        RecentPracticeSessionRow(practiceSession: session)
                                    }
                                case .profile:
                                    Profile(isSignedIn: $isSignedIn)
                                }
                            }
                        } else {
                            List(searchViewModel.searchResults) { piece in
                                RepertoireRow(piece: piece)
                            }
                        }
                    }
                }
            }
            .environmentObject(practiceSessionViewModel)
            .environmentObject(keyboardResponder)
            .onAppear {
                Task {
                    recentSessions = try await practiceSessionViewModel.getRecentUserPracticeSessions()
                }
            }
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

#Preview {
    let vm = PracticeSessionViewModel()
    vm.activeSession = PracticeSession.inProgressExample

    return ContentView(isSignedIn: .constant(true), practiceSessionViewModel: vm)
}

// www.swiftyplace.com/blog/swiftui-search-bar-best-practices-and-examples
