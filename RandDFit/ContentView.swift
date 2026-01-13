//
//  ContentView.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var settings: UserSettings

    private var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui_testing")
    }

    var body: some View {
        Group {
            if isUITesting || settings.hasOnboarded {
                TabView {
                    WorkoutView()
                        .tabItem { Label("Workout", systemImage: "figure.strengthtraining.traditional") }

                    SettingsView()
                        .tabItem { Label("Settings", systemImage: "gearshape") }
                }
            } else {
                OnboardingView()
            }
        }
        .task {
            if isUITesting {
                // Make screenshots deterministic (avoid onboarding in UI test runs).
                settings.hasOnboarded = true
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(UserSettings())
}
