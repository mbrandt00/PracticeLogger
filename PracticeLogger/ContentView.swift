//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    var body: some View {
        NavigationView {
            VStack {
                Text("Practice Logger").font(.title).padding()
                Image(systemName: "music.note")
                    .imageScale(.large)
                    .foregroundStyle(.tint).padding()
                Text("Recent Practice Sessions").font(.headline)
                NavigationSplitView {
                    List(modelData.pieces) { piece in
                        Text(piece.title)
                    }
                } detail: {
                    Text(
                        "Select a landmark"
                    )
                }
                NavigationLink(destination: NewPracticeSession()) {
                    Text("Add practice session")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            
        }
        .padding()
    }
}

#Preview {
    ContentView().environment(ModelData())
}
