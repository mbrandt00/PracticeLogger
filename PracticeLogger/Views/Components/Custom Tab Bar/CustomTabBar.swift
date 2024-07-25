//
//  CustomTabBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import Combine
import SwiftUI

enum Tabs {
    case progress, start, profile
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    @Binding var expandedSheet: Bool
    @EnvironmentObject var sessionManager: PracticeSessionViewModel
    var animation: Namespace.ID
    @ObservedObject private var keyboardResponder = KeyboardResponder()

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
            .safeAreaInset(edge: .bottom) {
                if let activeSession = sessionManager.activeSession {
                    CustomBottomSheet(animation: animation, expandedSheet: $expandedSheet, activeSession: activeSession)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom).combined(with: .opacity)))
                        .animation(.easeInOut(duration: 0.3))
                }
            }
            .frame(maxHeight: 100)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            .toolbar(expandedSheet ? .hidden : .visible, for: .tabBar)
            .opacity(keyboardResponder.isKeyboardVisible ? 0 : 1)
            .offset(y: keyboardResponder.isKeyboardVisible ? 100 : 0)
        }
        .animation(.easeInOut, value: keyboardResponder.isKeyboardVisible)
    }
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
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(Color.primary.opacity(0.2))
                .frame(height: 2)
        })
        .offset(y: -49)
    }
}

struct MusicInfo: View {
    @Binding var expandedSheet: Bool
    @ObservedObject var activeSession: PracticeSession
    var animation: Namespace.ID
    @State private var elapsedTime: String = "00:00"
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        HStack(spacing: 0) {
            // Left side: Timer
            ZStack {
                if !expandedSheet {
                    GeometryReader { geometry in
                        Text(elapsedTime)
                            .font(.caption)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                    .matchedGeometryEffect(id: "Artwork", in: animation)
                }
            }
            .frame(width: 45, height: 45)

            // Middle side: Composer name, Work name, Movement
            VStack(alignment: .leading, spacing: 5) {
                if let composerName = activeSession.piece?.composer?.name {
                    Text(composerName)
                        .font(.system(size: 10))
                        .foregroundColor(Color.secondary)
                }

                if let workName = activeSession.piece?.workName {
                    Text(workName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(Color.primary)
                }

                if let movementName = activeSession.movement?.name {
                    if let movementNumber = activeSession.movement?.number {
                        HStack {
                            Text(movementNumber.toRomanNumeral() ?? "")
                            Text(movementName)
                        }
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                    } else {
                        Text(movementName)
                            .font(.caption2)
                            .foregroundColor(Color.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .font(.system(size: 12, design: .serif))
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity)

            // Right side: Stop button
            Button(action: {
                Task {
                    await sessionManager.stopSession()
                }
            }) {
                Image(systemName: "stop.fill")
                    .font(.title2)
                    .foregroundColor(Color.primary)
            }
            .padding(.trailing, 20)
        }
        .padding(.horizontal)
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
    @Namespace var animation
    return CustomTabBar(selectedTab: .constant(.start), expandedSheet: .constant(false), animation: animation).preferredColorScheme(.dark).environmentObject(PracticeSessionViewModel())
}

#Preview {
    @Namespace var animation
    return CustomTabBar(selectedTab: .constant(.start), expandedSheet: .constant(false), animation: animation).environmentObject(PracticeSessionViewModel()).preferredColorScheme(.dark)
}
