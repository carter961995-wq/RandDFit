import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject private var settings: UserSettings

    @Environment(\.dismiss) private var dismiss

    @State private var isWorking = false
    @State private var statusText: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Difficulty") {
                    Toggle("Easy", isOn: binding(for: .easy))
                    Toggle("Moderate", isOn: binding(for: .moderate))
                    Toggle("Hard", isOn: binding(for: .hard))
                }

                Section("Beginner") {
                    Toggle("Show easier options", isOn: $settings.beginnerFriendly)
                }

                Section("Reminders") {
                    Stepper("Prompts per day: \(settings.promptsPerDay)", value: $settings.promptsPerDay, in: 1...12)

                    Picker("Start hour", selection: $settings.startHour) {
                        ForEach(0..<24, id: \.self) { h in
                            Text("\(h):00").tag(h)
                        }
                    }

                    Picker("End hour", selection: $settings.endHour) {
                        ForEach(0..<24, id: \.self) { h in
                            Text("\(h):00").tag(h)
                        }
                    }

                    if settings.endHour <= settings.startHour {
                        Text("End hour should be later than start hour.")
                            .foregroundStyle(.red)
                    }

                    Button {
                        Task { await requestNotifications() }
                    } label: {
                        Text("Request notification permission")
                    }
                    .disabled(isWorking)

                    Button {
                        Task { await scheduleReminders() }
                    } label: {
                        HStack {
                            Text("Schedule next 14 days")
                            Spacer()
                            if isWorking { ProgressView() }
                        }
                    }
                    .disabled(isWorking || settings.endHour <= settings.startHour)

                    Button(role: .destructive) {
                        Task { await clearReminders() }
                    } label: {
                        Text("Clear scheduled reminders")
                    }
                    .disabled(isWorking)

                    if let statusText {
                        Text(statusText)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func binding(for difficulty: Difficulty) -> Binding<Bool> {
        Binding(
            get: { settings.isDifficultyEnabled(difficulty) },
            set: { enabled in settings.setDifficulty(difficulty, enabled: enabled) }
        )
    }

    private func requestNotifications() async {
        isWorking = true
        defer { isWorking = false }
        let granted = await NotificationManager.shared.requestAuthorization()
        statusText = granted ? "Notifications enabled." : "Notifications not enabled."
    }

    private func scheduleReminders() async {
        isWorking = true
        defer { isWorking = false }

        let center = UNUserNotificationCenter.current()
        let currentSettings = await center.notificationSettings()
        if currentSettings.authorizationStatus != .authorized {
            let granted = await NotificationManager.shared.requestAuthorization()
            if !granted {
                statusText = "Notifications not enabled."
                return
            }
        }

        await NotificationManager.shared.scheduleRandomPrompts(
            days: 14,
            promptsPerDay: settings.promptsPerDay,
            startHour: settings.startHour,
            endHour: settings.endHour,
            allowedDifficulties: settings.allowedDifficulties,
            beginnerFriendly: settings.beginnerFriendly
        )
        statusText = "Scheduled reminders for the next 14 days."
    }

    private func clearReminders() async {
        isWorking = true
        defer { isWorking = false }
        await UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        statusText = "Cleared scheduled reminders."
    }
}

