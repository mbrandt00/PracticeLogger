//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import Apollo
import ApolloAPI
import ApolloGQL
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
                                    RecentPracticeSessions(practiceSessionViewModel: practiceSessionViewModel)
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
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

#Preview {
    ContentView(isSignedIn: .constant(true))
}

enum PieceNavigationContext: Hashable {
    case userPiece(Piece)
    case newPiece(Piece)
}
