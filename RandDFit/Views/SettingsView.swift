import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var settings: UserSettings

    @State private var notificationsEnabled: Bool = false
    @State private var isScheduling: Bool = false
    @State private var scheduleStatusText: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Difficulty") {
                    difficultyToggle(.easy)
                    difficultyToggle(.moderate)
                    difficultyToggle(.hard)

                    if settings.allowedDifficulties.isEmpty {
                        Text("Select at least one difficulty.")
                            .foregroundStyle(.red)
                    }
                }

                Section("Workout style") {
                    Toggle("Beginner friendly", isOn: $settings.beginnerFriendly)
                        .accessibilityIdentifier("beginner_friendly_toggle")
                }

                Section("Reminders (optional)") {
                    Stepper(value: $settings.promptsPerDay, in: 1...12) {
                        Text("Prompts per day: \(settings.promptsPerDay)")
                    }

                    Stepper(value: $settings.startHour, in: 0...23) {
                        Text("Start hour: \(settings.startHour):00")
                    }

                    Stepper(value: $settings.endHour, in: 0...23) {
                        Text("End hour: \(settings.endHour):00")
                    }

                    Button {
                        Task { await requestAndSchedule() }
                    } label: {
                        if isScheduling {
                            ProgressView()
                        } else {
                            Text("Enable & Schedule Notifications")
                        }
                    }
                    .disabled(isScheduling || settings.allowedDifficulties.isEmpty)
                    .accessibilityIdentifier("schedule_notifications_button")

                    if let scheduleStatusText {
                        Text(scheduleStatusText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Onboarding") {
                    Button(role: .destructive) {
                        settings.hasOnboarded = false
                    } label: {
                        Text("Show onboarding again")
                    }
                }
            }
            .accessibilityIdentifier("screen_settings")
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .task { await refreshNotificationStatus() }
        }
    }

    private func difficultyToggle(_ difficulty: Difficulty) -> some View {
        Toggle(difficulty.displayName, isOn: Binding(
            get: { settings.allowedDifficulties.contains(difficulty) },
            set: { isOn in
                if isOn {
                    settings.allowedDifficulties.insert(difficulty)
                } else {
                    settings.allowedDifficulties.remove(difficulty)
                }
            }
        ))
    }

    private func refreshNotificationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        notificationsEnabled = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
    }

    private func requestAndSchedule() async {
        isScheduling = true
        defer { isScheduling = false }

        let allowed = await NotificationManager.shared.requestAuthorization()
        await refreshNotificationStatus()

        guard allowed else {
            scheduleStatusText = "Notifications are disabled. Enable them in Settings to schedule reminders."
            return
        }

        await NotificationManager.shared.scheduleRandomPrompts(
            days: 14,
            promptsPerDay: settings.promptsPerDay,
            startHour: settings.startHour,
            endHour: settings.endHour,
            allowedDifficulties: settings.allowedDifficulties,
            beginnerFriendly: settings.beginnerFriendly
        )

        scheduleStatusText = "Scheduled prompts for the next 14 days."
        appState.generateWorkout(using: settings)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(UserSettings())
}

