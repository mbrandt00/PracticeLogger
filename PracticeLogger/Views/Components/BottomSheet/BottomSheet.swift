//
//  BottomSheet.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/16/25.
//
import ApolloGQL
import SwiftUI

struct BottomSheet: View {
    var animation: Namespace.ID
    @Binding var expandedSheet: Bool
    var activeSession: PracticeSessionDetails

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
        }
        .frame(height: 70)
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(Color.accentColor.opacity(0.8))
                .frame(height: 2)
        })
    }
}

struct MusicInfo: View {
    @Binding var expandedSheet: Bool
    @State var activeSession: PracticeSessionDetails
    var animation: Namespace.ID
    @State private var elapsedTime: String = "00:00"
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0.0) {
                if !expandedSheet {
                    Text(elapsedTime)
                        .font(.headline.bold())
                }

                Text(activeSession.piece.workName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundColor(Color.secondary)
                HStack {
                    if let movementName = activeSession.movement?.name {
                        if let movementNumber = activeSession.movement?.number {
                            HStack {
                                if let movementNumber = movementNumber.toRomanNumeral() {
                                    Text(movementNumber)
                                }
                                Text(movementName)
                            }

                        } else {
                            Text(movementName)
                        }
                    }

                    if let composerName = activeSession.piece.composer?.name {
                        if activeSession.movement?.name != nil {
                            Divider()
                        }
                        Text(composerName)
                    }
                }
                .font(.caption2)
                .foregroundColor(Color.secondary)
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .font(.system(size: 12, design: .serif))

            Button(action: {
                Task {
                    await sessionManager.stopSession()
                }
            }, label: {
                Image(systemName: "stop.fill")
                    .font(.title2)
                    .foregroundColor(Color.primary)
                    .padding(.trailing, 20)
            })
        }
        .padding()
        .frame(maxHeight: 70)
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
        .background(Color.gray.opacity(0.3))
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
