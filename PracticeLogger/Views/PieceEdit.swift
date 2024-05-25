//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import SwiftUI
import AlertToast

struct PieceEdit: View {
    @State var piece: Piece
    @ObservedObject var viewModel: PieceEditViewModel
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""
    @State private var duplicatePiece: Piece?

    init(piece: Piece) {
        self._piece = State(initialValue: piece)
        self.viewModel = PieceEditViewModel(piece: piece)
    }

    var body: some View {
        VStack {
            if let duplicatePiece = duplicatePiece {
                // Improve UI
                Text("Duplicate Piece Found:")
                    .font(.headline)
                Text("ID: \(duplicatePiece.id)")
            }
            Text(piece.workName)
                .font(.title)

            List {
                Section(header: Text("Movements")) {
                    ForEach(piece.movements.indices, id: \.self) { index in
                        MovementEditRow(
                            movement: piece.movements[index],
                            onUpdateMovementName: { newName in
                                viewModel.updateMovementName(at: index, newName: newName)
                            }
                        )
                    }.onMove(perform: viewModel.move)
                }

                Section(header: Text("Catalogue Information")) {
                    Picker("Identifier", selection: Binding(
                        get: {
                            print("CATALOGUETYPE", piece.catalogue_type)
                            return piece.catalogue_type?.rawValue ?? ""
                        },
                        set: { newValue in
                            piece.catalogue_type = CatalogueType(rawValue: newValue)
                        }
                    )) {
                        Text("").tag("")
                        ForEach(CatalogueType.allCases, id: \.self) { catalogue_type in
                            Text(catalogue_type.rawValue).tag(catalogue_type.rawValue)
                        }
                    }

                    HStack {
                        Text("Number")
                        Spacer()
                        TextField("", text: Binding(
                            get: {
                                if let catalogue_number = piece.catalogue_number {
                                    return String(catalogue_number)
                                } else {
                                    return ""
                                }
                            },
                            set: { newValue in
                                piece.catalogue_number = newValue.isEmpty ? nil : Int(newValue)
                            })
                        )
                        .frame(width: 200) // Adjust the width as needed
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                    }
                }
            }

            Button(action: {
                Task {
                    do {
                        let dbPiece = try await viewModel.insertPiece(piece: piece)

                    } catch {
                        if let supabaseError = error as? SupabaseError {
                            print(supabaseError)
                            switch supabaseError {
                            case .pieceAlreadyExists:
                                errorMessage = "You have already added this piece"
                            }
                        } else {
                            errorMessage = "An unexpected error occurred."
                        }
                        showToast = true
                    }
                }
            }, label: {
                Text("Create")
            })
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            .padding(3)

            Spacer()
        }
        .toast(isPresenting: $showToast) {
            AlertToast(type: .error(.red), title: errorMessage)
        }
        .onAppear {
            Task {
                do {
                    let updatedPiece = try await viewModel.addMetadata(to: piece)
                    let dbPiece = try await viewModel.isDuplicate(piece: piece)
                    dump(updatedPiece!)
                    self.piece = updatedPiece ?? piece
                    self.duplicatePiece = dbPiece

                } catch {
                    print(error)
                }
            }
        }
    }

    #Preview {
        PieceEdit(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements:
                                    [
                                        Movement(name: "Grave - Doppio movimento", number: 1),
                                        Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                        Movement(name: "Marche Fuenbre", number: 3),
                                        Movement(name: "Finale", number: 4)
                                    ], formattedKeySignature: "B♭ Minor"))
    }
}

struct PieceEdit_Previews: PreviewProvider {
    static var previews: some View {
        PieceEdit(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements:
                                [
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Funebre", number: 3),
                                    Movement(name: "Finale", number: 4)
                                ], formattedKeySignature: "B♭ Minor", catalogue_type: CatalogueType.Op, catalogue_number: 35))
    }
}
