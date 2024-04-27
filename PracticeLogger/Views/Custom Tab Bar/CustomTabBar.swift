//
//  CustomTabBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import SwiftUI

enum Tabs: Int {
    case progress = 0
    case start = 1
    case profile = 2

}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    @Binding var isTyping: Bool
    var body: some View {
        if !isTyping {
            Rectangle()
                .fill(Color.theme.gray)
                .frame(height: 1)
                .opacity(0.3)
            HStack(alignment: .center, spacing: 4) {

                Button {
                    selectedTab = .progress
                }label: {
                    TabBarButton(imageName: "chart.xyaxis.line", buttonText: "Progress", isActive: selectedTab == .progress)
                }

                Button {
                    selectedTab = .start
                }label: {
                    GeometryReader { geo in
                        VStack {
                            Image(systemName: "metronome")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24).foregroundColor(selectedTab == .start ? Color.theme.accent : Color.theme.gray)
                            Text("Start").font(.headline)
                        }.frame(width: geo.size.width, height: geo.size.height)
                    }
                }

                Button {
                    selectedTab = .profile
                }label: {
                    TabBarButton(imageName: "person", buttonText: "Profile", isActive: selectedTab == .profile)
                }
            }
            .frame(height: 82)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.profile), isTyping: .constant(false)).previewLayout(.sizeThatFits)
}
