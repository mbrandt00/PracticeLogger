//
//  SearchView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/5/24.
//

import ApolloGQL
import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        List {
            if !searchViewModel.userPieces.isEmpty {
                Section(header: Text("Pieces")) {
                    ForEach(searchViewModel.userPieces, id: \.id) { piece in
                        NavigationLink(
                            value: PieceNavigationContext.userPiece(piece),
                            label: {
                                RepertoireRow(piece: piece)
                            }
                        )
                    }
                }
            }
            if !searchViewModel.newPieces.isEmpty {
                Section(header: Text("New Pieces")) {
                    ForEach(searchViewModel.newPieces, id: \.id) { piece in
                        Button(action: {
                            searchViewModel.selectedPiece = piece
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(piece.workName)
                                        .font(.headline)
                                    if let composer = piece.composer {
                                        Text(composer.name)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()

                                Image(systemName: "plus.rectangle")
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .sheet(item: $searchViewModel.selectedPiece) { piece in // Use sheet(item:) instead of sheet(isPresented:)
                        NavigationStack {
                            PieceEdit(piece: piece) {
                                print("wow we are in complete")
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: searchViewModel.searchTerm, initial: true) {
            Task {
                await searchViewModel.searchPieces()
            }
        }
    }
}

// #Preview {
//    SearchView(searchViewModel: SearchViewModel())
// }

enum PieceNavigationContext: Hashable {
    case userPiece(PieceDetails)
    case newPiece(ImslpPieceDetails) // new piece
}

//
//// STOP USING PIECE DETAILS as type. Do search piece...
// struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = SearchViewModel()
//        viewModel.showingSheet = true
//        // Pre-populate some test data
//        viewModel.newPieces = [
//            PieceDetails(
//                id: "12345",
//                workName: "Symphony No. 5",
//                catalogueType: GraphQLEnum(CatalogueType.op.rawValue),
//                keySignature: GraphQLEnum(KeySignatureType.cminor),
//                format: GraphQLEnum(PieceFormat.symphony.rawValue),
//                instrumentation: ["Violin", "Cello", "Bassoon", "Chorus"],
//                wikipediaUrl: "https://en.wikipedia.org/wiki/Symphony_No._5_(Beethoven)",
//                imslpUrl: "https://imslp.org/wiki/Symphony_No.5,_Op.67_(Beethoven,_Ludwig_van)",
//                compositionYear: 1804,
//                catalogueNumber: 67,
//                nickname: "My really really really long nickname jkl;asd",
//                composer: PieceDetails.Composer(name: "Ludwig van Beethoven"),
//                movements: PieceDetails.Movements(
//                    edges: [
//                        PieceDetails.Movements.Edge(
//                            node: PieceDetails.Movements.Edge.Node(
//                                id: "1",
//                                name: "Allegro con brio",
//                                number: 1
//                            )
//                        ),
//                        PieceDetails.Movements.Edge(
//                            node: PieceDetails.Movements.Edge.Node(
//                                id: "2",
//                                name: "Andante con moto",
//                                number: 2
//                            )
//                        ),
//                        PieceDetails.Movements.Edge(
//                            node: PieceDetails.Movements.Edge.Node(
//                                id: "3",
//                                name: "Scherzo: Allegro",
//                                number: 3
//                            )
//                        ),
//                        PieceDetails.Movements.Edge(
//                            node: PieceDetails.Movements.Edge.Node(
//                                id: "4",
//                                name: "Allegro - Presto",
//                                number: 4
//                            )
//                        )
//                    ]
//                )
//            )
//        ]
//
//        return NavigationStack {
//            SearchView(searchViewModel: viewModel)
//        }
//    }
// }
