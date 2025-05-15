//
//  ActiveSession.swift
//  ActiveSession
//
//  Created by Michael Brandt on 5/13/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TimerActivityView: View {
    let context: ActivityViewContext<LiveActivityAttributes>
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 2)
                )
            
            VStack(spacing: 10) {
                // Header
                HStack {
                    Image(systemName: "music.note")
                        .foregroundColor(.purple)
                    
                    Text("Practice Session")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(context.state.startTime, style: .timer)
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                // Piece information
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.pieceName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    if let movementName = context.attributes.movementName {
                        HStack {
                            if let movementNumber = context.attributes.movementNumber {
                                Text("Movement \(movementNumber):")
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(movementName)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                        .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                
                Spacer()
                Button(intent: EndPracticeSessionIntent()) {
                    Label("End Session", systemImage: "xmark.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            .padding(12)
        }
    }
}

struct TimerView: View {
    let startTime: Date
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var elapsedTime: TimeInterval {
        currentTime.timeIntervalSince(startTime)
    }
    
    var body: some View {
        Text(timeString(from: elapsedTime))
            .font(.system(.headline, design: .monospaced))
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

struct ActiveSession: Widget {
    let kind: String = "ActiveSession"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen/banner UI
            TimerActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Label {
                            Text(context.attributes.pieceName)
                                .font(.system(size: 14, weight: .semibold))
                                .lineLimit(1)
                        } icon: {
                            Image(systemName: "music.note")
                                .foregroundColor(.purple)
                        }
                        
                        if let movementName = context.attributes.movementName,
                           let movementNumber = context.attributes.movementNumber
                        {
                            Text("Mvt. \(movementNumber): \(movementName)")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.leading, 4)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    // Elapsed time counter
                    Label {
                        Text(context.state.startTime, style: .timer)
                            .font(.system(.headline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    } icon: {
                        Image(systemName: "timer")
                            .foregroundColor(.blue)
                    }
                    .font(.headline)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    // Practice stats or controls could go here
                    HStack {
                        Button {
                            // Action to pause practice session
                        } label: {
                            Label("Pause", systemImage: "pause.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.orange)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Button(intent: EndPracticeSessionIntent()) {
                            Label("End Session", systemImage: "xmark.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                }
            } compactLeading: {
                // Compact leading - music icon
                Image(systemName: "music.note")
                    .foregroundColor(.purple)
            } compactTrailing: {
                // Compact trailing - timer
                TimerView(startTime: context.state.startTime)
                    .frame(width: 40)
            } minimal: {
                // Minimal - just a play icon
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.purple)
            }
        }
    }
}
