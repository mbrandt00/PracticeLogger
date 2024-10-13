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

enum Tabs: String {
    case progress = "Progress"
    case practice = "Practice"
    case profile = "Profile"
}

struct ContentView: View {
    @Binding var isSignedIn: Bool
    @State private var selectedTab: Tabs = .practice
    @Namespace private var animation
    @StateObject private var practiceSessionViewModel = PracticeSessionViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var keyboardResponder = KeyboardResponder()
    @State var searchIsFocused = false

    init(isSignedIn: Binding<Bool>, practiceSessionViewModel: PracticeSessionViewModel = PracticeSessionViewModel()) {
        self._isSignedIn = isSignedIn
        self._practiceSessionViewModel = StateObject(wrappedValue: practiceSessionViewModel)
    }

    var body: some View {
        if isSignedIn {
            NavigationStack {
                if !searchIsFocused {
                    ZStack {
                        TabView(selection: $selectedTab) {
                            ProgressView()
                                .tabItem {
                                    Label("Progress", systemImage: "chart.xyaxis.line")
                                }
                                .tag(Tabs.progress)

                            RecentPracticeSessions(practiceSessionViewModel: practiceSessionViewModel)
                                .tabItem {
                                    Label("Practice", systemImage: "metronome")
                                }
                                .tag(Tabs.practice)

                            Profile(isSignedIn: $isSignedIn)
                                .tabItem {
                                    Label("Profile", systemImage: "person")
                                }
                                .tag(Tabs.profile)
                        }
                        .edgesIgnoringSafeArea(.top)

                        // BottomSheet positioned above the TabView
                        if let activeSession = practiceSessionViewModel.activeSession {
                            GeometryReader { geometry in
                                VStack {
                                    Spacer()

                                    BottomSheet(
                                        animation: animation,
                                        expandedSheet: .constant(false),
                                        activeSession: PracticeSession(
                                            startTime: Date(),
                                            piece: Piece(workName: "Test Workname", composer: Composer(name: "Test Composer name", id: 1), movements: [])
                                        )
                                    )
                                    .transition(.move(edge: .bottom))
                                    .animation(.easeInOut(duration: 0.3))
                                    .padding(.bottom, geometry.safeAreaInsets.bottom + 49)
                                }
                                .edgesIgnoringSafeArea(.bottom)
                            }
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
            .environmentObject(practiceSessionViewModel)
            .environmentObject(keyboardResponder)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let practiceSessionViewModel = PracticeSessionViewModel()
        practiceSessionViewModel.setActiveSessionForPreview()

        return ContentView(isSignedIn: .constant(true), practiceSessionViewModel: practiceSessionViewModel)
    }
}

enum PieceNavigationContext: Hashable {
    case userPiece(Piece)
    case newPiece(Piece)
}
