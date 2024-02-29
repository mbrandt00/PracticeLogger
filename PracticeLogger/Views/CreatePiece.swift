//
//  CreatePiece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/28/24.
//

import SwiftUI
import MusicKit
struct CreatePiece: View {
    @State private var searchTerm = ""
    @State private var searchResults: [String] = []
    var body: some View {
        VStack {
                    TextField("Search for music", text: $searchTerm)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
            Button(action: {                Task {
                await searchMusic()
            }}) {
                        Text("Search")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    List(searchResults, id: \.self) { result in
                        Text(result)
                    }
                    .padding()
                }
    }
    func searchMusic() async {
        let auth = await MusicAuthorization.request()
        print("Auth", auth)
        do {
            let result = try await MusicCatalogSearchRequest(term: searchTerm, types: [Song.self] ).response()
            print(result)
        } catch {
            print("Error: \(error)")
            // Handle error
        }
    }
}


#Preview {
    CreatePiece()
}
