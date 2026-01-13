//
//  Workout.swift
//  RandDFit
//
//  Created by Logan Carter on 1/9/26.
//

import Foundation

enum Difficulty: String, CaseIterable, Codable, Hashable {
    case easy, moderate, hard
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
    let exerciseKind: ExerciseKind
    let steps: [String]

    init(title: String, minutes: Int, difficulty: Difficulty, equipment: Equipment, exerciseKind: ExerciseKind, steps: [String]) {
        self.id = UUID()
        self.title = title
        self.minutes = minutes
        self.difficulty = difficulty
        self.equipment = equipment
        self.exerciseKind = exerciseKind
        self.steps = steps
    }
}

