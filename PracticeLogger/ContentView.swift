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
    @StateObject private var practiceSessionViewModel = PracticeSessionViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()
    @State private var recentSessions: [PracticeSession] = []
    @State var searchIsFocused = false

    var body: some View {
        if isSignedIn {
            TabBarContainer(selectedTab: $selectedTab, isExpanded: $isExpanded) {
                NavigationStack {
                    VStack {
                        if !searchIsFocused {
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
                            SearchView(searchViewModel: searchViewModel)
                        }
                    }
                    .searchable(
                        text: $searchViewModel.searchTerm,
                        tokens: $searchViewModel.tokens,
                        isPresented: $searchIsFocused
                    ) { token in
                        Text(token.displayText())
                    }
                    .autocorrectionDisabled()
                    .onChange(of: searchViewModel.searchTerm) {
                        Task {
                            await searchViewModel.searchPieces()
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
    ContentView(isSignedIn: .constant(true))
}

// www.swiftyplace.com/blog/swiftui-search-bar-best-practices-and-examples

enum PieceNavigationContext: Hashable {
    case userPiece(Piece)
    case newPiece(Piece)
}
