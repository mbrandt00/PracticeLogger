//
//  SearchFilterBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/30/25.
//

import SwiftUI

struct SearchFilterBar: View {
    enum SearchFilter: String, CaseIterable, Identifiable {
        case all = "All" // eventual meilisearch multi index search
        case userPieces = "Library"
        case newPieces = "New pieces"
        case composers = "Composers"
        case collections = "Collections"

        var id: Self { self }
    }

    @Binding var selectedCategory: SearchFilter
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SearchFilter.allCases) { filter in
                    let categoryCount = viewModel.count(for: filter)
                    FilterButtonView(
                        text: "\(filter.rawValue) (\(categoryCount))",
                        isSelected: selectedCategory == filter
                    ) {
                        withAnimation {
                            selectedCategory = filter
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
}

struct SearchFilterBar_Previews: PreviewProvider {
    struct Container: View {
        @State private var selected: SearchFilterBar.SearchFilter = .all

        var body: some View {
            SearchFilterBar(selectedCategory: $selected, viewModel: SearchViewModel())
                .previewLayout(.sizeThatFits)
        }
    }

    static var previews: some View {
        Group {
            Container()
                .previewDisplayName("Filter Bar - All")

            Container()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Filter Bar - Dark Mode")
        }
    }
}
