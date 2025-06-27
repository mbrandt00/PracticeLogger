//
//  FeedbackView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/24/25.
//

import AlertToast
import Supabase
import SwiftUI

struct FeedbackView: View {
    private enum Field: Hashable {
        case title
        case description
    }

    @State private var title = ""
    @State private var description = ""
    @State private var issueType = "Bug"
    @State private var isSubmitting = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isSuccess = false
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            Form {
                Picker("Type", selection: $issueType) {
                    Text("Bug").tag("Bug")
                    Text("Feature").tag("Feature")
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Title", text: $title)
                    .focused($focusedField, equals: .title)

                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(5, reservesSpace: true)
                    .focused($focusedField, equals: .description)

                Button("Submit") {
                    Task {
                        isSubmitting = true
                        defer { isSubmitting = false }
                        do {
                            let response: BugReportResponse = try await Database.client.functions
                                .invoke(
                                    "create-triage-ticket",
                                    options: FunctionInvokeOptions(
                                        body: ["title": title, "description": description, "issueType": issueType]
                                    )
                                )

                            if response.success {
                                toastMessage = "Report submitted successfully!"
                                isSuccess = true
                                title = ""
                                description = ""
                                focusedField = .title
                            } else {
                                toastMessage = response.error ?? "Failed to submit report"
                                isSuccess = false
                            }

                            showToast = true
                        } catch {
                            toastMessage = "Error: \(error.localizedDescription)"
                            isSuccess = false
                            showToast = true
                        }
                    }
                }
                .disabled(title.isEmpty || isSubmitting)
            }
            .disabled(isSubmitting) // prevent interaction during submission

            if isSubmitting {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    ProgressView("Submitting...")
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isSubmitting)
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Submit feedback")
        .toast(isPresenting: $showToast) {
            AlertToast(
                displayMode: .banner(.pop),
                type: isSuccess ? .complete(.green) : .error(.red),
                title: toastMessage
            )
        }
    }
}

struct BugReportResponse: Decodable {
    let success: Bool
    let issue: LinearIssue?
    let error: String?
}

struct LinearIssue: Decodable {
    let id: String
    let title: String
}

#Preview {
    NavigationStack {
        FeedbackView()
    }
}
