//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tabs = .progress
    var body: some View {
        VStack {
            Text("Hello")
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
