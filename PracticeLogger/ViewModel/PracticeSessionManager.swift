//
//  PracticeSessionManager.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/29/24.
//

import Combine
import Foundation
import Supabase

class PracticeSessionManager: ObservableObject {
    @Published var activeSession: PracticeSession?
    private var cancellables: Set<AnyCancellable> = []
    private var currentTaskID: UUID = .init()
}
