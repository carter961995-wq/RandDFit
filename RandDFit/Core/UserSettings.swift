import Foundation

@MainActor
final class UserSettings: ObservableObject {
    private let defaults: UserDefaults

    @Published var hasOnboarded: Bool {
        didSet { defaults.set(hasOnboarded, forKey: Keys.hasOnboarded) }
    }

    @Published var allowedDifficulties: Set<Difficulty> {
        didSet {
            let csv = allowedDifficulties.map(\.rawValue).sorted().joined(separator: ",")
            defaults.set(csv, forKey: Keys.difficultyCSV)
        }
    }

    @Published var promptsPerDay: Int {
        didSet { defaults.set(promptsPerDay, forKey: Keys.promptsPerDay) }
    }

    @Published var startHour: Int {
        didSet { defaults.set(startHour, forKey: Keys.startHour) }
    }

    @Published var endHour: Int {
        didSet { defaults.set(endHour, forKey: Keys.endHour) }
    }

    @Published var beginnerFriendly: Bool {
        didSet { defaults.set(beginnerFriendly, forKey: Keys.beginnerFriendly) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        self.hasOnboarded = defaults.bool(forKey: Keys.hasOnboarded)

        let csv = defaults.string(forKey: Keys.difficultyCSV) ?? "easy,moderate"
        let parts = csv.split(separator: ",").map(String.init)
        let diffs = parts.compactMap(Difficulty.init(rawValue:))
        self.allowedDifficulties = Set(diffs.isEmpty ? Difficulty.allCases : diffs)

        let prompts = defaults.object(forKey: Keys.promptsPerDay) as? Int ?? 4
        self.promptsPerDay = max(1, min(12, prompts))

        let start = defaults.object(forKey: Keys.startHour) as? Int ?? 6
        let end = defaults.object(forKey: Keys.endHour) as? Int ?? 19
        self.startHour = max(0, min(23, start))
        self.endHour = max(0, min(23, end))

        self.beginnerFriendly = defaults.object(forKey: Keys.beginnerFriendly) as? Bool ?? true
    }
}

private enum Keys {
    static let hasOnboarded = "hasOnboarded"
    static let difficultyCSV = "difficultyCSV"
    static let promptsPerDay = "promptsPerDay"
    static let startHour = "startHour"
    static let endHour = "endHour"
    static let beginnerFriendly = "beginnerFriendly"
}

