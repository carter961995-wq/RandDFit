//
//  AppState.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var currentWorkout: Workout = Workout(
        title: "Loading…",
        minutes: 1,
        difficulty: .easy,
        equipment: .none,
        exerciseKind: .pushUps,
        steps: []
    )

    func generateWorkout(using settings: UserSettings) {
        currentWorkout = PromptGenerator.makeWorkout(
            allowedDifficulties: settings.allowedDifficulties,
            beginnerFriendly: settings.beginnerFriendly
        )
    }

    func markDone(using settings: UserSettings) {
        generateWorkout(using: settings)
    }
}
