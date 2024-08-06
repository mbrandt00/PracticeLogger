//
//  SearchView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/5/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        VStack {
            Picker("Key Signature", selection: $searchViewModel.selectedKeySignature) {
                Text("Key Signature").tag(KeySignatureType?.none) // Default value
                ForEach(KeySignatureType.allCases) { keySignature in
                    Text(keySignature.rawValue).tag(KeySignatureType?(keySignature))
                }
            }
            .pickerStyle(MenuPickerStyle())

            List(searchViewModel.searchResults) { piece in
                RepertoireRow(piece: piece)
            }
        }
    }
}

// #Preview {
//    SearchView()
// }
