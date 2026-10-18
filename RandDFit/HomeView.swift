import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    @State private var isUpdatingReminders = false
    @State private var scheduleStatus: String?

    var body: some View {
        NavigationStack {
            ScrollView {
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
                        if isUpdatingReminders {
                            ProgressView()
                        } else {
                            Label("Reschedule reminders", systemImage: "bell.badge")
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isUpdatingReminders)

                    Button("Clear scheduled reminders", role: .destructive) {
                        Task { await clearReminders() }
                    }
                    .disabled(isUpdatingReminders)

                    if let scheduleStatus {
                        Text(scheduleStatus)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Text("Reminders cover a limited period. Reschedule them here to keep receiving prompts.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("RanDoFit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings") {
                        settings.hasOnboarded = false
                    }
                    .disabled(isUpdatingReminders)
                }
            }
            .onAppear {
                if appState.currentWorkout.steps.isEmpty {
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
        guard !isUpdatingReminders else { return }
        scheduleStatus = nil
        isUpdatingReminders = true
        defer { isUpdatingReminders = false }

        let authorized = await NotificationManager.shared.requestAuthorization()
        guard authorized else {
            scheduleStatus = ReminderScheduleError.notificationsDisabled.localizedDescription
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
            scheduleStatus = error.localizedDescription
        }
    }

    private func clearReminders() async {
        guard !isUpdatingReminders else { return }
        scheduleStatus = nil
        isUpdatingReminders = true
        defer { isUpdatingReminders = false }

        do {
            try await NotificationManager.shared.clearScheduledPrompts()
            scheduleStatus = "Cleared scheduled reminders."
        } catch {
            scheduleStatus = error.localizedDescription
        }
    }
}
