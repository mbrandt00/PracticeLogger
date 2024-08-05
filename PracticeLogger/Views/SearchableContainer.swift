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
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        NavigationStack {
            VStack {
                // Show Picker only when searching
                if isSearching {
                    Picker("Key Signature", selection: $searchViewModel.selectedKeySignature) {
                        Text("Key Signature").tag(KeySignatureType?.none) // Default value
                        ForEach(KeySignatureType.allCases) { keySignature in
                            Text(keySignature.rawValue).tag(KeySignatureType?(keySignature))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // Content based on search term
                content(searchViewModel)
                    .searchable(
                        text: $searchTerm,
                        tokens: $searchViewModel.tokens
                    ) { token in
                        Text(token.displayText())
                    }
                    .onChange(of: searchTerm) {
                        searchViewModel.searchTerm = searchTerm
                        Task {
                            await searchViewModel.searchPieces()
                        }
                    }
                    .autocorrectionDisabled()
                    .onAppear {
                        searchViewModel.searchTerm = searchTerm
                    }
                if isSearching {
                    Text("Searching")
                } else {
                    Text("not searching")
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SearchableContainer { searchViewModel in
        ContentView(isSignedIn: .constant(true), searchViewModel: searchViewModel)
    }
}
