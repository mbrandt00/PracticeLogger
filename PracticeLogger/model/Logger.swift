//
//  Logger.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/17/24.
//

import Foundation
import OSLog
import Supabase

extension Logger {
  static let main = Self(subsystem: "com.supabase.SlackClone", category: "app")
}

@Observable
final class LogStore: SupabaseLogger {
  private let lock = NSLock()
  private var loggers: [String: Logger] = [:]
  private var currentTaskID: UUID = UUID()

  static let shared = LogStore()

  @MainActor
  var messages: [SupabaseLogMessage] = []

  func log(message: SupabaseLogMessage) {
    Task {
      await add(message: message)
    }

    lock.withLock {
      if loggers[message.system] == nil {
        loggers[message.system] = Logger(
          subsystem: Bundle.main.bundleIdentifier!,
          category: message.system
        )
      }

      let logger = loggers[message.system]!

      switch message.level {
      case .debug: logger.debug("\(message, privacy: .public)")
      case .error: logger.error("\(message, privacy: .public)")
      case .verbose: logger.info("\(message, privacy: .public) taskId: \(self.currentTaskID)")
      case .warning: logger.notice("\(message, privacy: .public)")
      }
    }
  }

  @MainActor
  private func add(message: SupabaseLogMessage) {
    messages.insert(message, at: 0)
  }
}
