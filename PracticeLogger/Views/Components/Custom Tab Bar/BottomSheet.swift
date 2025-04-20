//
//  BottomSheet.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import Combine
import SwiftUI

enum Tabs {
    case progress, start, profile
}

struct BottomSheet: View {
    var animation: Namespace.ID
    @Binding var isExpanded: Bool
    var activeSession: PracticeSession
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThickMaterial)
                .overlay {
                    MusicInfo(expandedSheet: $isExpanded, activeSession: activeSession, animation: animation)
                        .matchedGeometryEffect(id: "BGVIEW", in: animation)
                }
            Rectangle()
                .fill(.ultraThickMaterial)
                .overlay {
                    MusicInfo(expandedSheet: $isExpanded, activeSession: activeSession, animation: animation)
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
//                if !expandedSheet {
                GeometryReader { geometry in
                    Text(elapsedTime)
                        .font(.caption)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                .matchedGeometryEffect(id: "Artwork", in: animation)
//                }
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
            }, label: {
                Image(systemName: "stop.fill")
                    .font(.title2)
                    .foregroundColor(Color.primary)
            })
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
    return BottomSheet(animation: animation, isExpanded: .constant(false), activeSession: PracticeSession.example).preferredColorScheme(.dark).environmentObject(PracticeSessionViewModel())
}
