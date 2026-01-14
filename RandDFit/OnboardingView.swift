import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    @State private var isWorking = false
    @State private var statusText: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("RandFit")
                    .font(.largeTitle.bold())

                Text("Quick, random bodyweight prompts — plus optional “round bell” reminders during your day.")
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 10) {
                    Label("Tap ✅ to get the next random prompt", systemImage: "checkmark.circle")
                    Label("Choose difficulty + beginner options in Settings", systemImage: "slider.horizontal.3")
                    Label("Schedule reminders (optional)", systemImage: "bell")
                }
                .font(.body)

                if let statusText {
                    Text(statusText)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }

                Spacer()

                Button {
                    Task { await enableRemindersAndContinue() }
                } label: {
                    HStack {
                        Spacer()
                        if isWorking { ProgressView().padding(.trailing, 6) }
                        Text("Enable reminders & continue")
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isWorking)

                Button {
                    continueWithoutReminders()
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue without reminders")
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isWorking)
            }
            .padding()
        }
    }

    private func enableRemindersAndContinue() async {
        isWorking = true
        defer { isWorking = false }

        let granted = await NotificationManager.shared.requestAuthorization()
        if granted {
            await NotificationManager.shared.scheduleRandomPrompts(
                days: 14,
                promptsPerDay: settings.promptsPerDay,
                startHour: settings.startHour,
                endHour: settings.endHour,
                allowedDifficulties: settings.allowedDifficulties,
                beginnerFriendly: settings.beginnerFriendly
            )
            statusText = "Reminders scheduled."
        } else {
            statusText = "Notifications weren’t enabled. You can turn them on later in Settings."
        }

        continueWithoutReminders()
    }

    private func continueWithoutReminders() {
        settings.hasOnboarded = true
        appState.generateWorkout(using: settings)
    }
}

