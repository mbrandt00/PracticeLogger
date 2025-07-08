//
//  SearchFilterBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/30/25.
//

import SwiftUI

struct SearchFilterBar: View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SearchViewModel.SearchFilter.allCases) { filter in
                    let categoryCount = viewModel.count(for: filter)
                    FilterButtonView(
                        text: "\(filter.rawValue) (\(categoryCount))",
                        isSelected: viewModel.searchFilter == filter
                    ) {
                        withAnimation {
                            viewModel.searchFilter = filter
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
        var body: some View {
            SearchFilterBar(viewModel: SearchViewModel())
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
