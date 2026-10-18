//
//  ContentView.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if settings.hasOnboarded {
            HomeView()
        } else {
            OnboardingView()
        }
    }

    @EnvironmentObject private var settings: UserSettings
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
        .environmentObject(AppState())
}
