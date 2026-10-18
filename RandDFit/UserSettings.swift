import Combine
import Foundation

@MainActor
final class UserSettings: ObservableObject {
    private let defaults: UserDefaults

    @Published var hasOnboarded: Bool {
        didSet { defaults.set(hasOnboarded, forKey: "hasOnboarded") }
    }

    @Published private var difficultyCSV: String {
        didSet { defaults.set(difficultyCSV, forKey: "difficultyCSV") }
    }

    @Published var promptsPerDay: Int {
        didSet { defaults.set(promptsPerDay, forKey: "promptsPerDay") }
    }

    @Published var startHour: Int {
        didSet { defaults.set(startHour, forKey: "startHour") }
    }

    @Published var endHour: Int {
        didSet { defaults.set(endHour, forKey: "endHour") }
    }

    @Published var beginnerFriendly: Bool {
        didSet { defaults.set(beginnerFriendly, forKey: "beginnerFriendly") }
    }

    var allowedDifficulties: Set<Difficulty> {
        get {
            Set(difficultyCSV.split(separator: ",").compactMap {
                Difficulty(rawValue: String($0))
            })
        }
        set {
            // Keep the user's last choice instead of unexpectedly enabling harder workouts.
            guard !newValue.isEmpty else { return }
            difficultyCSV = newValue.map(\.rawValue).sorted().joined(separator: ",")
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hasOnboarded = defaults.bool(forKey: "hasOnboarded")

        let storedCSV = defaults.string(forKey: "difficultyCSV") ?? "easy,moderate"
        let difficulties = Set(storedCSV.split(separator: ",").compactMap {
            Difficulty(rawValue: String($0))
        })
        difficultyCSV = difficulties.isEmpty
            ? Difficulty.easy.rawValue
            : difficulties.map(\.rawValue).sorted().joined(separator: ",")

        let storedPrompts = defaults.object(forKey: "promptsPerDay") as? Int ?? 4
        let storedStart = defaults.object(forKey: "startHour") as? Int ?? 6
        let storedEnd = defaults.object(forKey: "endHour") as? Int ?? 19
        promptsPerDay = min(12, max(1, storedPrompts))
        startHour = min(23, max(0, storedStart))
        endHour = min(23, max(0, storedEnd))
        beginnerFriendly = defaults.object(forKey: "beginnerFriendly") as? Bool ?? true
    }
}
