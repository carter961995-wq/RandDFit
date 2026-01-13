import Foundation

enum Difficulty: String, CaseIterable, Codable, Hashable {
    case easy, moderate, hard

    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .moderate: return "Moderate"
        case .hard: return "Hard"
        }
    }
}

enum Equipment: String, CaseIterable, Codable, Hashable {
    case none
}

struct Workout: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let minutes: Int
    let difficulty: Difficulty
    let equipment: Equipment
    let steps: [String]

    init(title: String, minutes: Int, difficulty: Difficulty, equipment: Equipment, steps: [String]) {
        self.id = UUID()
        self.title = title
        self.minutes = minutes
        self.difficulty = difficulty
        self.equipment = equipment
        self.steps = steps
    }
}

