//
//  CustomTabBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import SwiftUI

enum Tabs {
    case progress, start, profile
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    @Binding var isTyping: Bool

    var body: some View {
        VStack {

                TabView(selection: $selectedTab) {
                    Text("")
                        .tabItem {
                            Image(systemName: "chart.xyaxis.line")
                            Text("Progress")
                        }
                        .tag(Tabs.progress)

                   Text("")
                        .tabItem {
                            Image(systemName: "metronome")
                            Text("Practice")
                        }
                        .tag(Tabs.start)

                    Text("")
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(Tabs.profile)
                }
                .frame(height: 100)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            }
        }
    }

#Preview {
    ContentView(isSignedIn: true)
}
