//
//  CustomTabBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import SwiftUI
import Combine
enum Tabs {
    case progress, start, profile
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    @Binding var isTyping: Bool
    /// Animation Properties
    @Binding var expandedSheet: Bool
    var animation: Namespace.ID
    @EnvironmentObject var practiceSessionManager: PracticeSessionManager

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
//                .tint(.accentColor)

                .safeAreaInset(edge: .bottom) {
                    if let activeSession = practiceSessionManager.activeSession {
                        CustomBottomSheet(animation: animation, expandedSheet: $expandedSheet, activeSession: activeSession)
                    }
                }

                .frame(height: 100)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                .toolbar(expandedSheet ? .hidden : .visible, for: .tabBar)
            }
        }
    /// Custom Bottom Sheet

    }
struct CustomBottomSheet: View {
    var animation: Namespace.ID
    @Binding var expandedSheet: Bool
    var activeSession: PracticeSession
    var body: some View {
        ZStack {
            if expandedSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        MusicInfo(expandedSheet: $expandedSheet, activeSession: activeSession, animation: animation)
                             .matchedGeometryEffect(id: "BGVIEW", in: animation)
                    }
            }
            Rectangle()
                .fill(.ultraThickMaterial)
                .overlay {
                    MusicInfo(expandedSheet: $expandedSheet, activeSession: activeSession, animation: animation)
                }
        }
        .frame(height: 70)
        /// Seperator
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.2))
                .frame(height: 2)
        })
        /// 49: Default Tab Bar Height
        .offset(y: -49)
    }
}

struct MusicInfo: View {
    @Binding var expandedSheet: Bool
    var activeSession: PracticeSession
    var animation: Namespace.ID
    @State private var elapsedTime: String = "00:00"

    var body: some View {
        HStack(spacing: 0) {
            // Left side: Timer
            ZStack {
                if !expandedSheet {
                    GeometryReader { _ in
                        Text(elapsedTime)
                            .font(.caption) // Use .caption for smaller text
                    }
                    .matchedGeometryEffect(id: "Artwork", in: animation)
                }
            }
            .frame(width: 45, height: 45)

            // Middle side: Composer name, Work name, Movement
            VStack(alignment: .leading, spacing: 5) {
                Text("Composer: \(activeSession.piece?.composer?.name ?? "No composer")")
                    .font(.headline)
                    .foregroundColor(.black)

                Text("Work: \(activeSession.piece?.workName ?? "")")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.black)

                Text("Movement: \(activeSession.movement?.name ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity)

            // Right side: Stop button
            Button(action: {

            }) {
                Image(systemName: "stop.fill")
                    .font(.title2)
            }
            .padding(.trailing, 20)
        }
        .foregroundColor(.black)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandedSheet = true
            }
        }
        .onAppear {
            updateElapsedTime()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateElapsedTime()
        }
    }

    private func updateElapsedTime() {
        let elapsedTimeInterval = Date().timeIntervalSince(activeSession.startTime)
        let hours = Int(elapsedTimeInterval) / 3600
        let minutes = (Int(elapsedTimeInterval) % 3600) / 60
        let seconds = Int(elapsedTimeInterval) % 60

        if hours > 0 {
            elapsedTime = String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            elapsedTime = String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
#Preview {
    ContentView(isSignedIn: true).preferredColorScheme(.dark)
}
