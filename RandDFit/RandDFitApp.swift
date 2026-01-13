//
//  RandDFitApp.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

@main
struct RandDFitApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var settings = UserSettings()

    init() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-reset_defaults") {
            let defaults = UserDefaults.standard
            for key in ["hasOnboarded", "difficultyCSV", "promptsPerDay", "startHour", "endHour", "beginnerFriendly"] {
                defaults.removeObject(forKey: key)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(settings)
        }
    }
}
