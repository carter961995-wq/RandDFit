//
//  OnboardingView.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    @State private var isRequestingNotifications = false
    @State private var notificationEnabled: Bool? = nil
    @State private var errorMessage: String? = nil

    private var isTimeWindowValid: Bool {
        settings.endHour > settings.startHour
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RandDFit")
                            .font(.title2)
                            .bold()
                        Text("Random 1‑minute workouts + optional notifications.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Difficulty") {
                    difficultyToggleRow(.easy, label: "Easy")
                    difficultyToggleRow(.moderate, label: "Moderate")
                    difficultyToggleRow(.hard, label: "Hard")

                    if settings.allowedDifficulties.isEmpty {
                        Text("Pick at least one difficulty.")
                            .foregroundStyle(.red)
                    }
                }

                Section("Notifications") {
                    Stepper("Prompts per day: \(settings.promptsPerDay)", value: $settings.promptsPerDay, in: 1...12)
                    Stepper("Start hour: \(settings.startHour):00", value: $settings.startHour, in: 0...23)
                    Stepper("End hour: \(settings.endHour):00", value: $settings.endHour, in: 0...23)
                    Toggle("Beginner-friendly cues", isOn: $settings.beginnerFriendly)

                    if !isTimeWindowValid {
                        Text("End hour must be later than start hour.")
                            .foregroundStyle(.red)
                    }

                    HStack {
                        Spacer()
                        Button {
                            Task { await enableAndScheduleNotifications() }
                        } label: {
                            if isRequestingNotifications {
                                ProgressView()
                            } else {
                                Text("Enable & schedule prompts")
                            }
                        }
                        .disabled(isRequestingNotifications || !isTimeWindowValid)
                        Spacer()
                    }

                    if let notificationEnabled {
                        Text(notificationEnabled ? "Notifications enabled." : "Notifications not enabled.")
                            .foregroundStyle(notificationEnabled ? .green : .secondary)
                    }
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button {
                        appState.generateWorkout(using: settings)
                        settings.hasOnboarded = true
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(settings.allowedDifficulties.isEmpty)
                }
            }
            .navigationTitle("Get started")
        }
    }

    @ViewBuilder
    private func difficultyToggleRow(_ difficulty: Difficulty, label: String) -> some View {
        Button {
            toggleDifficulty(difficulty)
        } label: {
            HStack {
                Text(label)
                Spacer()
                Image(systemName: settings.allowedDifficulties.contains(difficulty) ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(settings.allowedDifficulties.contains(difficulty) ? .tint : .secondary)
            }
        }
        .buttonStyle(.plain)
    }

    private func toggleDifficulty(_ difficulty: Difficulty) {
        var set = settings.allowedDifficulties
        if set.contains(difficulty) {
            set.remove(difficulty)
        } else {
            set.insert(difficulty)
        }
        settings.allowedDifficulties = set
    }

    private func enableAndScheduleNotifications() async {
        errorMessage = nil
        isRequestingNotifications = true
        defer { isRequestingNotifications = false }

        guard isTimeWindowValid else { return }

        let ok = await NotificationManager.shared.requestAuthorization()
        notificationEnabled = ok

        guard ok else {
            errorMessage = "Permission denied. You can enable notifications in Settings."
            return
        }

        await NotificationManager.shared.scheduleRandomPrompts(
            promptsPerDay: settings.promptsPerDay,
            startHour: settings.startHour,
            endHour: settings.endHour,
            allowedDifficulties: settings.allowedDifficulties,
            beginnerFriendly: settings.beginnerFriendly
        )
    }
}

