//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tabs = .start
    let bpm: Double = 60
    var body: some View {
        VStack {
//            TimelineView(.periodic(from: .now, by: 60 / bpm)) { timeline in
//                        MetronomeBack()
//                            .overlay(MetronomePendulum(bpm: bpm, date: timeline.date))
//                            .overlay(MetronomeFront(), alignment: .bottom)
//                    }
            if selectedTab == .start {
                CreatePiece()
            }
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    NavigationView {
        ContentView().navigationBarHidden(true)

    }
}
