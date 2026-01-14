//
//  RandDFitApp.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

@main
struct RandDFitApp: App {
    @StateObject private var settings = UserSettings()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(appState)
        }
    }
}
