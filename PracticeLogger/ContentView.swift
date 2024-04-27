//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI
import MusicKit
struct ContentView: View {
    @State var selectedTab: Tabs = .start
    @State var isTyping: Bool = false
    let bpm: Double = 60
    var body: some View {
        VStack {
            if selectedTab == .start {
                CreatePiece(isTyping: $isTyping)
            }
            Spacer()
            CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping).navigationBarHidden(true)
        }
    }
}

#Preview {
    NavigationView {
        ContentView() // .navigationBarHidden(true)

    }
}
