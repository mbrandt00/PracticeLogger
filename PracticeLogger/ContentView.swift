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

    var body: some View {
        if isSignedIn {
            NavigationStack {
                VStack {
                    if searchViewModel.searchTerm.isEmpty {
                        VStack {
                            switch selectedTab {
                            case .progress:
                                ProgressView()
                            case .start:
                                Text("Recent pieces...")
                            case .profile:
                                Profile(isSignedIn: $isSignedIn)
                            }
                        }
                        .environmentObject(practiceSessionViewModel)
                        Spacer()
                        if !isExpanded && !keyboardResponder.isKeyboardVisible {
                            TabBar(selectedTab: $selectedTab, expandedSheet: $isExpanded, animation: animation)
                                .environmentObject(practiceSessionViewModel)
                                .animation(.easeInOut(duration: 0.9), value: keyboardResponder.isKeyboardVisible)
                                .onAppear {
                                    Task {
                                        do {
                                            practiceSessionViewModel.activeSession = await practiceSessionViewModel.fetchCurrentActiveSession()
                                        }
                                    }
                                }
                        }
                    } else {
                        List(searchViewModel.pieces) { piece in
                            Text(piece.workName)
                        }
                    }
                }
                .searchable(
                    text: $searchViewModel.searchTerm,
                    tokens: $searchViewModel.tokens,
                    suggestedTokens: $searchViewModel.suggestedTokens
                ) { token in
                    Text(token.displayText) // Customize token appearance
                }
                .onChange(of: searchViewModel.searchTerm) { _ in
                    searchViewModel.updateTokens()
                    Task {
                        await searchViewModel.getClassicalPieces()
                    }
                }
                .autocorrectionDisabled()
            }
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Initialize your view model
//        let viewModel = PracticeSessionViewModel()
//        viewModel.activeSession = PracticeSession.example()
//
//        // Pass the view model and a constant binding to ContentView
//        ContentView(isSignedIn: .constant(true), viewModel: viewModel)
//    }
// }

#Preview {
    let vm = PracticeSessionViewModel()
    vm.activeSession = PracticeSession.inProgressExample

    return ContentView(isSignedIn: .constant(true), practiceSessionViewModel: vm)
}

// www.swiftyplace.com/blog/swiftui-search-bar-best-practices-and-examples
