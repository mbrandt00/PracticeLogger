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
    @Published private var recentSessions: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge] = []
    private var liveActivity: Activity<LiveActivityAttributes>?

    init() {
        NotificationCenter.default.addObserver(
            forName: .endPracticeSessionFromWidget,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task {
                await self?.stopSession()
                self?.stopLiveActivity()
            }
        }
    }

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
                    if let insertedPiece = graphqlResult.data?.insertIntoPracticeSessionsCollection?.records.first {
                        self.activeSession = insertedPiece.fragments.practiceSessionDetails
                        let attributes = LiveActivityAttributes(pieceName: insertedPiece.piece.workName, movementName: insertedPiece.movement?.name, movementNumber: insertedPiece.movement?.number)
                        let state = LiveActivityAttributes.ContentState(startTime: Date())
                        let content = ActivityContent(state: state, staleDate: nil)

                        self.liveActivity = try? Activity<LiveActivityAttributes>.request(attributes: attributes, content: content)

                        continuation.resume(returning: insertedPiece)
                    }

                case let .failure(error):
                    print("error in starting session", error)
                    continuation.resume(throwing: RuntimeError(error.localizedDescription))
                }
            }
        }
    }

    func getRecentUserPracticeSessions() async throws -> [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge] {
        let userId = try await Database.client.auth.user().id.uuidString

        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: RecentUserSessionsQuery(userId: userId)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let practiceSessions = graphQlResult.data?.practiceSessionsCollection?.edges {
                        self.recentSessions = practiceSessions
                        continuation.resume(returning: practiceSessions)
                    } else {
                        continuation.resume(returning: [])
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @MainActor
    func stopSession() async {
        print("In stop session block")
        do {
            _ = try await Database.client
                .from("practice_sessions")
                .update(["end_time": Date()])
                .eq("id", value: activeSession?.id)
                .execute()
            activeSession = nil
        } catch {
            print("Error updating end_time: \(error)")
        }
    }

    func fetchCurrentActiveSession() async throws -> PracticeSessionDetails? {
        let userId = try await Database.client.auth.user().id.uuidString

        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: ActiveUserSessionQuery(userId: userId)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let currentlyActiveSession = graphQlResult.data?.practiceSessionsCollection?.edges.first?.node.fragments.practiceSessionDetails {
                        self.activeSession = currentlyActiveSession

                        continuation.resume(returning: currentlyActiveSession)
                    } else {
                        // Resume with nil if no sessions found
                        continuation.resume(returning: nil)
                    }

                case let .failure(error):
                    print("GraphQL query failed: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func stopLiveActivity() {
        Task {
            await liveActivity?.end(nil, dismissalPolicy: .immediate)
            liveActivity = nil
        }
    }
}
