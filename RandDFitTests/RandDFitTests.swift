import Combine
import Foundation
import XCTest
@testable import RandDFit

final class RandDFitTests: XCTestCase {
    @MainActor
    func testOnboardingPublishesAndSurvivesRelaunch() async throws {
        let suiteName = "RandDFitTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let settings = UserSettings(defaults: defaults)
        var didPublish = false
        let subscription = settings.objectWillChange.sink { _ in didPublish = true }

        settings.hasOnboarded = true

        XCTAssertTrue(didPublish, "The root view must be notified when onboarding finishes.")
        XCTAssertTrue(UserSettings(defaults: defaults).hasOnboarded)
        withExtendedLifetime(subscription) {}
    }

    @MainActor
    func testRemovingLastDifficultyPreservesChoice() async throws {
        let suiteName = "RandDFitTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let settings = UserSettings(defaults: defaults)
        settings.allowedDifficulties = [.easy]
        settings.allowedDifficulties = []

        XCTAssertEqual(settings.allowedDifficulties, [.easy])
        XCTAssertEqual(UserSettings(defaults: defaults).allowedDifficulties, [.easy])
        XCTAssertEqual(defaults.string(forKey: "difficultyCSV"), "easy")
    }

    @MainActor
    func testExistingSettingsKeysLoadAndInvalidValuesStayConservative() async throws {
        let suiteName = "RandDFitTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        defaults.set(true, forKey: "hasOnboarded")
        defaults.set("unrecognized", forKey: "difficultyCSV")
        defaults.set(200, forKey: "promptsPerDay")
        defaults.set(-5, forKey: "startHour")
        defaults.set(99, forKey: "endHour")
        defaults.set(false, forKey: "beginnerFriendly")

        let settings = UserSettings(defaults: defaults)

        XCTAssertTrue(settings.hasOnboarded)
        XCTAssertEqual(settings.allowedDifficulties, [.easy])
        XCTAssertEqual(settings.promptsPerDay, 12)
        XCTAssertEqual(settings.startHour, 0)
        XCTAssertEqual(settings.endHour, 23)
        XCTAssertFalse(settings.beginnerFriendly)
    }

    @MainActor
    func testReminderQueueIsBoundedUniqueFutureAndWithinDailyWindow() async throws {
        let calendar = utcCalendar
        let now = date(hour: 12, minute: 34, second: 30)
        let dates = try ReminderSchedulePlanner.dates(
            promptsPerDay: 12,
            startHour: 6,
            endHour: 19,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(dates.count, 64)
        XCTAssertEqual(Set(dates).count, dates.count)
        XCTAssertEqual(dates, dates.sorted())
        var countsByDay: [Date: Int] = [:]

        for scheduled in dates {
            XCTAssertGreaterThan(scheduled, now)
            XCTAssertGreaterThanOrEqual(calendar.component(.hour, from: scheduled), 6)
            XCTAssertLessThan(calendar.component(.hour, from: scheduled), 19)
            XCTAssertEqual(calendar.component(.second, from: scheduled), 0)
            countsByDay[calendar.startOfDay(for: scheduled), default: 0] += 1
        }
        XCTAssertTrue(countsByDay.values.allSatisfy { $0 <= 12 })
    }

    @MainActor
    func testTodayUsesRemainingMinuteInsteadOfDroppingPastRandomSlots() async throws {
        let dates = try ReminderSchedulePlanner.dates(
            days: 1,
            promptsPerDay: 12,
            startHour: 6,
            endHour: 19,
            now: date(hour: 18, minute: 58, second: 30),
            calendar: utcCalendar
        )

        XCTAssertEqual(dates, [date(hour: 18, minute: 59)])
    }

    @MainActor
    func testInvalidReminderSettingsAreRejected() async {
        XCTAssertThrowsError(try ReminderSchedulePlanner.dates(
            promptsPerDay: 4, startHour: 19, endHour: 6
        ))
        XCTAssertThrowsError(try ReminderSchedulePlanner.dates(
            promptsPerDay: 0, startHour: 6, endHour: 19
        ))
        XCTAssertThrowsError(try ReminderSchedulePlanner.dates(
            days: 0, promptsPerDay: 4, startHour: 6, endHour: 19
        ))
    }

    @MainActor
    func testExpiredWindowDoesNotProduceAnEmptySuccess() async {
        XCTAssertThrowsError(try ReminderSchedulePlanner.dates(
            days: 1,
            promptsPerDay: 4,
            startHour: 6,
            endHour: 19,
            now: date(hour: 20),
            calendar: utcCalendar
        ))
    }

    @MainActor
    func testEmptyDifficultyFallbackIsEasy() async {
        let workout = PromptGenerator.makeWorkout(allowedDifficulties: [], beginnerFriendly: true)
        XCTAssertEqual(workout.difficulty, .easy)
        XCTAssertFalse(workout.steps.isEmpty)
    }

    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private func date(hour: Int, minute: Int = 0, second: Int = 0) -> Date {
        utcCalendar.date(from: DateComponents(
            year: 2026, month: 10, day: 17, hour: hour, minute: minute, second: second
        ))!
    }
}
