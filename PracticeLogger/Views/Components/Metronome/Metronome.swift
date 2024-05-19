//
//  Metronome.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import SwiftUI

struct Metronome: View {
    let bpm: Double = 60 // beats per minute

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60 / bpm)) { timeline in
            MetronomeBack()
                .overlay(MetronomePendulum(bpm: bpm, date: timeline.date))
                .overlay(MetronomeFront(), alignment: .bottom)
        }
    }
}
