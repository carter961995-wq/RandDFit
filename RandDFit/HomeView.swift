//
//  HomeView.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    @State private var isScheduling = false
    @State private var scheduleStatus: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                workoutCard

                Button {
                    appState.markDone(using: settings)
                } label: {
                    Label("Next workout", systemImage: "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    Task { await rescheduleNotifications() }
                } label: {
                    if isScheduling {
                        ProgressView()
                    } else {
                        Label("Reschedule notifications", systemImage: "bell.badge")
                    }
                }
                .buttonStyle(.bordered)

                if let scheduleStatus {
                    Text(scheduleStatus)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("RandDFit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        settings.hasOnboarded = false
                    }
                }
            }
            .onAppear {
                if appState.currentWorkout.title == "Loading…" {
                    appState.generateWorkout(using: settings)
                }
            }
        }
    }

    private var workoutCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(appState.currentWorkout.title)
                    .font(.title3)
                    .bold()
                Spacer()
                Text(appState.currentWorkout.difficulty.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: Capsule())
            }

            if shouldShowIllustration {
                ExerciseIllustrationView(kind: appState.currentWorkout.exerciseKind)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                ForEach(appState.currentWorkout.steps.indices, id: \.self) { idx in
                    Text("• \(appState.currentWorkout.steps[idx])")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var shouldShowIllustration: Bool {
        settings.beginnerFriendly || appState.currentWorkout.difficulty == .easy
    }

    private func rescheduleNotifications() async {
        scheduleStatus = nil
        isScheduling = true
        defer { isScheduling = false }

        let ok = await NotificationManager.shared.requestAuthorization()
        guard ok else {
            scheduleStatus = "Notifications are not enabled (check iOS Settings)."
            return
        }

        await NotificationManager.shared.scheduleRandomPrompts(
            promptsPerDay: settings.promptsPerDay,
            startHour: settings.startHour,
            endHour: settings.endHour,
            allowedDifficulties: settings.allowedDifficulties,
            beginnerFriendly: settings.beginnerFriendly
        )
        scheduleStatus = "Scheduled prompts for the next 14 days."
    }
}

