//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import SwiftUI
import AlertToast
struct PieceEdit: View {
    @StateObject private var viewModel: PieceEditViewModel
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""
    @State private var duplicatePiece: Piece?
    @Binding var isTyping: Bool

    init(piece: Piece, isTyping: Binding<Bool>) {
          _viewModel = StateObject(wrappedValue: PieceEditViewModel(piece: piece))
          self._isTyping = isTyping
      }

    var body: some View {
        VStack {
            if let duplicatePiece = duplicatePiece {
                Text("Duplicate Piece Found:")
                    .font(.headline)
                Text("ID: \(duplicatePiece.id)")
            }
            Text(viewModel.piece.workName)
                .font(.title)

            Form {
                Section(header: Text("Movements")) {
                    ForEach(viewModel.piece.movements.indices, id: \.self) { index in
                        MovementEditRow(
                            movement: viewModel.piece.movements[index],
                            onUpdateMovementName: { newName in
                                viewModel.updateMovementName(at: index, newName: newName)
                            },
                            isTyping: $isTyping
                        )
                    }
                    .onMove(perform: viewModel.move)
                }

                Section(header: Text("Catalogue Information")) {
                    Picker("Identifier", selection: Binding(
                        get: {
                            return viewModel.piece.catalogue_type?.rawValue ?? ""
                        },
                        set: { newValue in
                            viewModel.piece.catalogue_type = CatalogueType(rawValue: newValue)
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
                                if let catalogue_number = viewModel.piece.catalogue_number {
                                    return String(catalogue_number)
                                } else {
                                    return ""
                                }
                            },
                            set: { newValue in
                                viewModel.piece.catalogue_number = newValue.isEmpty ? nil : Int(newValue)
                            }
                        ), onEditingChanged: { isEditing in
                            isTyping = isEditing
                        })
                        .frame(width: 200)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                    }

                    VStack {
                        HStack {
                            Picker("Key Signature", selection: Binding(
                                get: {
                                    viewModel.piece.key_signature?.rawValue ?? ""
                                },
                                set: { newValue in
                                    viewModel.piece.key_signature = KeySignatureType(rawValue: newValue)
                                }
                            )) {
                                Text("").tag("")
                                ForEach(KeySignatureType.allCases, id: \.self) { keySignatureType in
                                    Text(keySignatureType.rawValue).tag(keySignatureType.rawValue)
                                }
                            }
                        }

                        HStack {
                            Picker("Tonality", selection: Binding(
                                get: {
                                    viewModel.piece.tonality?.rawValue ?? ""
                                },
                                set: { newValue in
                                    viewModel.piece.tonality = KeySignatureTonality(rawValue: newValue)
                                }
                            )) {
                                ForEach(KeySignatureTonality.allCases, id: \.self) { tonality in
                                    Text(tonality.rawValue).tag(tonality.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    Picker("Format", selection: Binding(
                        get: {
                            viewModel.piece.format?.rawValue ?? ""
                        },
                        set: { newValue in
                            viewModel.piece.format = Format(rawValue: newValue)
                        }
                    )) {
                        Text("").tag("")
                        ForEach(Format.allCases, id: \.self) { format in
                            Text(format.rawValue).tag(format.rawValue)
                        }
                    }
                    HStack {
                        Text("Nickname")
                        Spacer()
                        TextField("", text: Binding(
                            get: {
                                if let nickname = viewModel.piece.nickname {
                                    return nickname
                                } else {
                                    return ""
                                }
                            },
                            set: { newValue in
                                viewModel.piece.nickname = newValue.isEmpty ? nil : newValue
                            }
                        ), onEditingChanged: { isEditing in
                            isTyping = isEditing
                        })
                        .frame(width: 200)
                        .multilineTextAlignment(.trailing)
                    }
                }
            .toast(isPresenting: $showToast) {
                AlertToast(type: .error(.red), title: errorMessage)
            }
        }
            Button(action: {
                Task {
                    do {
                        try await viewModel.insertPiece(piece: viewModel.piece)
                        // toast success/redirect
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
            .padding(5)
        }
    }
}

struct PieceEdit_Previews: PreviewProvider {
    static var previews: some View {
        PieceEdit(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements: [
            Movement(name: "Grave - Doppio movimento", number: 1),
            Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
            Movement(name: "Marche Funebre", number: 3),
            Movement(name: "Finale", number: 4)
        ], formattedKeySignature: "Bb Minor", catalogue_type: CatalogueType.Op, catalogue_number: 35, nickname: "Funeral March", tonality: KeySignatureTonality.minor, key_signature: KeySignatureType.bFlat), isTyping: .constant(false))
    }
}
