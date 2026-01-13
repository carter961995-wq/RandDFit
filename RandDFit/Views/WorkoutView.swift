import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var settings: UserSettings

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(appState.currentWorkout.title)
                            .font(.title.bold())

                        Spacer()

                        Text(appState.currentWorkout.difficulty.displayName)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                    }

                    if !appState.currentWorkout.steps.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(appState.currentWorkout.steps.enumerated()), id: \.offset) { idx, step in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("\(idx + 1).")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                        .frame(width: 26, alignment: .trailing)
                                    Text(step)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    } else {
                        ContentUnavailableView("No workout yet", systemImage: "figure.strengthtraining.traditional") {
                            Text("Tap New Workout to generate one.")
                        }
                        .padding(.vertical, 24)
                    }

                    HStack(spacing: 12) {
                        Button {
                            appState.generateWorkout(using: settings)
                        } label: {
                            Label("New Workout", systemImage: "sparkles")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("new_workout_button")

                        Button {
                            appState.markDone(using: settings)
                        } label: {
                            Text("Done ✅")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("done_workout_button")
                    }
                }
                .padding()
                .accessibilityIdentifier("screen_workout")
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if appState.currentWorkout.title == "Loading…" {
                appState.generateWorkout(using: settings)
            }
        }
    }
}

#Preview {
    WorkoutView()
        .environmentObject(AppState())
        .environmentObject(UserSettings())
}

