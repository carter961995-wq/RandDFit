import Foundation
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    @State private var isRequestingNotifications = false
    @State private var scheduleStatus: String?
    @State private var errorMessage: String?

    private var isTimeWindowValid: Bool {
        settings.endHour > settings.startHour
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RanDoFit")
                            .font(.title2)
                            .bold()
                        Text("Short, random workouts with optional reminders.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Difficulty") {
                    difficultyToggleRow(.easy, label: "Easy")
                    difficultyToggleRow(.moderate, label: "Moderate")
                    difficultyToggleRow(.hard, label: "Hard")

                    Text("Keep at least one difficulty selected.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Reminders") {
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
                        .disabled(!isTimeWindowValid)
                        Spacer()
                    }

                    if let scheduleStatus {
                        Text(scheduleStatus)
                            .foregroundStyle(.secondary)
                    }
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }

                    Text("Changing preferences does not change existing reminders until you schedule again.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button {
                        appState.generateWorkout(using: settings)
                        settings.hasOnboarded = true
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .accessibilityIdentifier("continue_button")
                }
            }
            .disabled(isRequestingNotifications)
            .navigationTitle("Get started")
        }
    }

    private func difficultyToggleRow(_ difficulty: Difficulty, label: String) -> some View {
        let isSelected = settings.allowedDifficulties.contains(difficulty)
        let isLastSelection = isSelected && settings.allowedDifficulties.count == 1

        return Button {
            var selected = settings.allowedDifficulties
            if selected.contains(difficulty) {
                selected.remove(difficulty)
            } else {
                selected.insert(difficulty)
            }
            settings.allowedDifficulties = selected
        } label: {
            HStack {
                Text(label)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            }
        }
        .buttonStyle(.plain)
        .disabled(isLastSelection)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }

    private func enableAndScheduleNotifications() async {
        guard !isRequestingNotifications, isTimeWindowValid else { return }
        errorMessage = nil
        scheduleStatus = nil
        isRequestingNotifications = true
        defer { isRequestingNotifications = false }

        let authorized = await NotificationManager.shared.requestAuthorization()
        guard authorized else {
            errorMessage = ReminderScheduleError.notificationsDisabled.localizedDescription
            return
        }

        do {
            let result = try await NotificationManager.shared.scheduleRandomPrompts(
                promptsPerDay: settings.promptsPerDay,
                startHour: settings.startHour,
                endHour: settings.endHour,
                allowedDifficulties: settings.allowedDifficulties,
                beginnerFriendly: settings.beginnerFriendly
            )
            scheduleStatus = result.summary
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
