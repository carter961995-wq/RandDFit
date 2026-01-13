import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: UserSettings

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("RandDFit")
                    .font(.largeTitle.bold())

                Text("Get quick, random “round bell” micro-workouts throughout your day.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 10) {
                    Label("Pick your difficulty", systemImage: "slider.horizontal.3")
                    Label("Beginner-friendly options", systemImage: "figure.walk")
                    Label("Optional reminders", systemImage: "bell")
                }
                .font(.headline)

                Spacer()

                Button {
                    settings.hasOnboarded = true
                } label: {
                    Text("Get Started")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("get_started_button")
            }
            .padding()
            .accessibilityIdentifier("screen_onboarding")
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(UserSettings())
}

