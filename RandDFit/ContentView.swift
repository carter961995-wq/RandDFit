//
//  ContentView.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var settings: UserSettings
    @EnvironmentObject private var appState: AppState

    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(appState.currentWorkout.title)
                        .font(.largeTitle.bold())

                    HStack(spacing: 10) {
                        Text(appState.currentWorkout.difficulty.rawValue.capitalized)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.thinMaterial)
                            .clipShape(Capsule())

                        Text("~\(appState.currentWorkout.minutes) min")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if appState.currentWorkout.steps.isEmpty {
                        Text("Tap ✅ to generate your first prompt.")
                            .foregroundStyle(.secondary)
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(appState.currentWorkout.steps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("•")
                                    Text(step)
                                }
                            }
                        }
                        .font(.body)
                    }

                    Spacer(minLength: 12)

                    HStack(spacing: 12) {
                        Button {
                            appState.markDone(using: settings)
                        } label: {
                            Label("Done", systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        Button {
                            appState.generateWorkout(using: settings)
                        } label: {
                            Label("Shuffle", systemImage: "shuffle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .navigationTitle("RandFit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .task {
            if appState.currentWorkout.steps.isEmpty {
                appState.generateWorkout(using: settings)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
        .environmentObject(AppState())
}
