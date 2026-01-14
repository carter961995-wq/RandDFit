import SwiftUI

struct RootView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if settings.hasOnboarded {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        .task {
            if appState.currentWorkout.title == "Loading…" {
                appState.generateWorkout(using: settings)
            }
        }
    }
}

