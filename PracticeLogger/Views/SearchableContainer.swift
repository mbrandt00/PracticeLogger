//
//  SearchableContent.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/2/24.
//

import SwiftUI

struct SearchableContainer<Content: View>: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchTerm = ""

    let content: (SearchViewModel) -> Content

    var body: some View {
        NavigationStack {
            content(searchViewModel)
                .searchable(
                    text: $searchTerm,
                    tokens: $searchViewModel.tokens,
                    suggestedTokens: $searchViewModel.suggestedTokens
                ) { token in
                    Text(token.displayText) // Customize token appearance
                }
                .onChange(of: searchTerm) {
                    searchViewModel.searchTerm = searchTerm
                    searchViewModel.updateTokens()
                    Task {
                        await searchViewModel.getClassicalPieces()
                    }
                }
                .autocorrectionDisabled()
                .onAppear {
                    searchViewModel.searchTerm = searchTerm
                }
        }
    }
}

#Preview {
    SearchableContainer { searchViewModel in
        ContentView(isSignedIn: .constant(true), searchViewModel: searchViewModel)
    }
}
