//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tabs = .start
    var body: some View {
        VStack() {
            if selectedTab == .start {
                Text("on start")
            }
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
