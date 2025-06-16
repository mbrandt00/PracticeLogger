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
    func getRecentUserPracticeSessions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let userId = try await Database.client.auth.user().id.uuidString

            let sessions = try await withCheckedThrowingContinuation { continuation in
                Network.shared.apollo.fetch(
                    query: RecentUserSessionsQuery(userId: userId),
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

    @MainActor
    func stopSession() async {
        do {
            _ = try await Database.client
                .from("practice_sessions")
                .update(["end_time": Date()])
                .eq("id", value: activeSession?.id)
                .execute()
            activeSession = nil
            await getRecentUserPracticeSessions()
        } catch {
            print("Error updating end_time: \(error)")
        }
        Task {
            await self.liveActivity?.end(nil, dismissalPolicy: .immediate)
            self.liveActivity = nil
        }
    }

    @MainActor
    func fetchCurrentActiveSession() async throws -> PracticeSessionDetails? {
        let userId = try await Database.client.auth.user().id.uuidString

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PracticeSessionDetails?, Error>) in
            Network.shared.apollo.fetch(query: ActiveUserSessionQuery(userId: userId)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let session = graphQlResult.data?.practiceSessionsCollection?.edges.first?.node.fragments.practiceSessionDetails {
                        self.activeSession = session
                        self.startLiveActivity(practiceSession: session, startTime: session.startTime)
                        continuation.resume(returning: session)
                    } else {
                        self.clearAppGroupSessionDefaults()
                        self.activeSession = nil
                        continuation.resume(returning: nil)
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
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
