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

    init(piece: Piece) {
        _viewModel = StateObject(wrappedValue: PieceEditViewModel(piece: piece))
    }

    var body: some View {
        VStack {
            Form {
                Text(viewModel.piece.workName)
                    .font(.title)
                    .foregroundColor(.primary) // Adapts to light and dark mode

                if duplicatePiece != nil {
                    Text("Duplicate Piece Found!")
                        .font(.subheadline)
                        .foregroundColor(.red) // Red text for emphasis
                }

                Section(header: Text("Movements").foregroundColor(.primary)) {
                    ForEach(viewModel.piece.movements.indices, id: \.self) { index in
                        MovementEditRow(
                            movement: viewModel.piece.movements[index],
                            onUpdateMovementName: { newName in
                                viewModel.updateMovementName(at: index, newName: newName)
                            }
                        )
                    }
                    .onMove(perform: viewModel.move)
                }

                Section(header: Text("Catalogue Information").foregroundColor(.primary)) {
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
                            .foregroundColor(.primary)
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
                        ))
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
                            .foregroundColor(.primary)
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
                        ))
                        .frame(width: 200)
                        .multilineTextAlignment(.trailing)
                    }
                }
                .onAppear {
                    Task {
                        do {
                            self.duplicatePiece = try await viewModel.isDuplicate(piece: viewModel.piece)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .toast(isPresenting: $showToast) {
                AlertToast(type: .error(.red), title: errorMessage)
            }
        }
        .navigationBarItems(
            trailing: Button(action: {
                Task {
                    do {
                        _ = try await viewModel.insertPiece(piece: viewModel.piece)
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
                    .foregroundColor(.primary) // Ensure button text adapts to dark mode
            })
        )
        .buttonStyle(.bordered)
        .foregroundColor(.primary) // Ensure button text adapts to dark mode
    }
}

struct PieceEdit_Previews: PreviewProvider {
    static var previews: some View {
        PieceEdit(piece: Piece.example)
            .environment(\.colorScheme, .dark) // Preview in dark mode
    }
}
