//
//  BugReportView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/24/25.
//

import AlertToast
import Supabase
import SwiftUI

struct BugReportView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var issueType = "Bug"
    @State private var isSubmitting = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Picker("Type", selection: $issueType) {
                Text("Bug").tag("Bug")
                Text("Feature").tag("Feature")
            }
            .pickerStyle(SegmentedPickerStyle())

            TextField("Title", text: $title)

            TextField("Description", text: $description, axis: .vertical)
                .lineLimit(5, reservesSpace: true)

            Button("Submit") {
                Task {
                    isSubmitting = true

                    do {
                        let response: BugReportResponse = try await Database.client.functions
                            .invoke(
                                "create-triage-ticket",
                                options: FunctionInvokeOptions(
                                    body: ["title": title, "description": description, "issueType": issueType]
                                )
                            )

                        if response.success {
                            print("Bug report created successfully: \(response.issue?.id ?? "Unknown ID")")
                            toastMessage = "Report submitted successfully!"
                            isSuccess = true
                            showToast = true

                            // Delay dismiss to show toast
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismiss()
                            }
                        } else {
                            toastMessage = response.error ?? "Failed to submit report"
                            isSuccess = false
                            showToast = true
                        }
                    } catch {
                        toastMessage = "Error: \(error.localizedDescription)"
                        isSuccess = false
                        showToast = true
                    }

                    isSubmitting = false
                }
            }
            .disabled(title.isEmpty || description.isEmpty || isSubmitting)
        }
        .navigationTitle("Report Bug")
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
