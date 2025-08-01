//
//  PracticeSessionViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//
import ActivityKit
import Apollo
import ApolloGQL
import Foundation
import Supabase
import SwiftUI

class PracticeSessionViewModel: ObservableObject {
    @Published var activeSession: PracticeSessionDetails?
    @Published var recentSessions: [PracticeSessionDetails] = []
    @Published var isLoading = false

    private var liveActivity: Activity<LiveActivityAttributes>?

    func startSession(pieceId: Int, movementId: Int?) async throws {
        let graphqlInsertObject = PracticeSessionsInsertInput(
            startTime: .some(Date()),
            pieceId: .some(BigInt(pieceId)),
            movementId: movementId != nil ? .some(BigInt(movementId!)) : .null
        )
        _ = try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.perform(mutation: CreatePracticeSessionMutation(input: graphqlInsertObject)) { result in
                switch result {
                case let .success(graphqlResult):
                    if let practiceSession = graphqlResult.data?.insertIntoPracticeSessionsCollection?.records.first?.fragments.practiceSessionDetails {
                        self.activeSession = practiceSession
                        self.startLiveActivity(practiceSession: practiceSession)
                        continuation.resume(returning: practiceSession)
                    }

                case let .failure(error):
                    print("error in starting session", error)
                    continuation.resume(throwing: RuntimeError(error.localizedDescription))
                }
            }
        }
    }

    @MainActor
    func deleteSession(_ session: PracticeSessionDetails) async {
        if session.deletedAt != nil { return }
        var updateDict = ["deleted_at": Date()]
        if session.endTime == nil {
            updateDict["end_time"] = Date()
        }
        do {
            _ = try await Database.client
                .from("practice_sessions")
                .update(updateDict)
                .eq("id", value: session.id)
                .execute()
            withAnimation {
                if let index = recentSessions.firstIndex(where: { $0.id == session.id }) {
                    recentSessions.remove(at: index)
                }
                if activeSession?.id == session.id {
                    stopLiveActivity()
                    activeSession = nil
                }
            }
        } catch {
            print(error)
        }
    }

    @MainActor
    func getRecentUserPracticeSessions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let userId = try await Database.client.auth.user().id.uuidString
            let filter = GraphQLNullable.some(
                PracticeSessionsFilter(
                    and: .some([
                        PracticeSessionsFilter(
                            userId: .some(UUIDFilter(eq: .some(userId)))
                        ),
                        PracticeSessionsFilter(
                            deletedAt: .some(DatetimeFilter(is: .some(GraphQLEnum(.null))))
                        ),
                    ])
                )
            )
            let sessions = try await withCheckedThrowingContinuation { continuation in

                Network.shared.apollo.fetch(
                    query: PracticeSessionsQuery(filter: filter),
                    cachePolicy: .fetchIgnoringCacheData
                ) { result in
                    switch result {
                    case let .success(graphQlResult):
                        if let data = graphQlResult.data,
                           let edges = data.practiceSessionsCollection?.edges
                        {
                            let sessions = edges.compactMap { $0.node.fragments.practiceSessionDetails }
                            continuation.resume(returning: sessions)
                        } else {
                            continuation.resume(returning: [])
                        }

                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            recentSessions = sessions
        } catch {
            print("❌ Error fetching recent sessions: \(error)")
        }
    }

    /// Optimistically stops the current session. Rolls back on error
    @MainActor
    func stopSession() async throws {
        guard let session = activeSession else {
            throw RuntimeError("No active session to stop.")
        }

        let previousSession = session

        // Optimistically update UI
        activeSession = nil
        stopLiveActivity()

        do {
            _ = try await Database.client
                .from("practice_sessions")
                .update(["end_time": Date()])
                .eq("id", value: session.id)
                .execute()
        } catch {
            print("❌ Failed to update end_time: \(error)")

            //  Rollback
            activeSession = previousSession
            startLiveActivity(practiceSession: previousSession, startTime: previousSession.startTime)

            throw error
        }

        await getRecentUserPracticeSessions()
    }

    @MainActor
    func fetchCurrentActiveSession() async throws {
        let userId = try await Database.client.auth.user().id.uuidString

        let filter = GraphQLNullable.some(
            PracticeSessionsFilter(
                and: .some([
                    PracticeSessionsFilter(
                        userId: .some(UUIDFilter(eq: .some(userId)))
                    ),
                    PracticeSessionsFilter(
                        endTime: .some(DatetimeFilter(is: .some(GraphQLEnum(.null))))
                    ),
                ])
            )
        )
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Network.shared.apollo.fetch(query: PracticeSessionsQuery(filter: filter), cachePolicy: .fetchIgnoringCacheCompletely) { result in
                Task { @MainActor in
                    switch result {
                    case let .success(graphQlResult):
                        if let session = graphQlResult.data?.practiceSessionsCollection?.edges.first?.node.fragments.practiceSessionDetails {
                            self.activeSession = session
                            self.startLiveActivity(practiceSession: session, startTime: session.startTime)
                        } else {
                            self.clearAppGroupSessionDefaults()
                            self.activeSession = nil
                        }
                        continuation.resume()

                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    func stopLiveActivity() {
        Task {
            await self.liveActivity?.end(nil, dismissalPolicy: .immediate)
            self.liveActivity = nil
        }
    }

    private func startLiveActivity(practiceSession: PracticeSessionDetails, startTime: Date = Date()) {
        activeSession = practiceSession
        let attributes = LiveActivityAttributes(
            pieceName: practiceSession.piece.workName,
            movementName: practiceSession.movement?.name,
            movementNumber: practiceSession.movement?.number
        )
        let state = LiveActivityAttributes.ContentState(startTime: startTime)
        let content = ActivityContent(state: state, staleDate: nil)
        if Activity<LiveActivityAttributes>.activities.isEmpty {
            liveActivity = try? Activity<LiveActivityAttributes>.request(attributes: attributes, content: content)
        }

        persistSessionToAppGroup(sessionId: practiceSession.id, startTime: Date())
    }

    private func persistSessionToAppGroup(sessionId: String, startTime: Date) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.michaelbrandt.PracticeLogger") else {
            print("❌ Failed to get shared UserDefaults")
            return
        }

        sharedDefaults.set(sessionId, forKey: "currentSessionId")
        sharedDefaults.set(startTime, forKey: "currentSessionStartTime")
        sharedDefaults.synchronize()
    }

    private func clearAppGroupSessionDefaults() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.michaelbrandt.PracticeLogger") else { return }
        sharedDefaults.removeObject(forKey: "currentSessionId")
        sharedDefaults.removeObject(forKey: "currentSessionStartTime")
        sharedDefaults.synchronize()
    }
}
