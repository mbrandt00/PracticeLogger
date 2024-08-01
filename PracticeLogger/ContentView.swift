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
    @State private var searchIsFocused = false

    var body: some View {
        if isSignedIn {
            if isExpanded {
                if let activeSession = practiceSessionViewModel.activeSession {
                    ExpandedBottomSheet(expandSheet: $isExpanded, activeSession: activeSession, animation: animation)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            } else {
                NavigationStack {
                    VStack {
                        TextField("Search...", text: $searchViewModel.searchTerm)
                            .searchable(
                                text: $searchViewModel.searchTerm,
                                tokens: $searchViewModel.tokens,
                                suggestedTokens: $searchViewModel.tokens,
                                prompt: "Search"
                            ) { token in
                                Text(token.displayText) // Customize token appearance
                            }
                            .onChange(of: searchViewModel.searchTerm) { _ in
                                searchViewModel.updateTokens()
                            }
                            .autocorrectionDisabled()
                    }
                }

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
