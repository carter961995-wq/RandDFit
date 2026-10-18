import Foundation
import UserNotifications

enum ReminderScheduleError: LocalizedError {
    case invalidSettings
    case noFutureTimes
    case notificationsDisabled
    case alreadyUpdating
    case schedulingFailed(scheduled: Int, requested: Int)

    nonisolated var errorDescription: String? {
        switch self {
        case .invalidSettings:
            return "Choose at least one difficulty, 1–12 prompts per day, and an end hour later than the start hour."
        case .noFutureTimes:
            return "There are no future reminder times in that window. Choose a later end time and try again."
        case .notificationsDisabled:
            return "Enable notifications for RanDoFit in the Settings app, then try again."
        case .alreadyUpdating:
            return "A reminder update is already in progress. Please wait for it to finish."
        case let .schedulingFailed(scheduled, requested):
            return "Scheduled \(scheduled) of \(requested) reminders. The remaining reminders could not be saved. Please reschedule to try again."
        }
    }
}

struct ReminderScheduleResult {
    let scheduledCount: Int
    let lastScheduledDate: Date

    var summary: String {
        let lastTime = lastScheduledDate.formatted(date: .abbreviated, time: .shortened)
        return "Scheduled \(scheduledCount) reminders through \(lastTime)."
    }
}

/// Plans a bounded queue using local calendar dates, without touching notification permissions.
enum ReminderSchedulePlanner {
    static let maximumPendingRequests = 64

    static func dates(
        days: Int = 14,
        promptsPerDay: Int,
        startHour: Int,
        endHour: Int,
        now: Date = Date(),
        calendar: Calendar = .current
    ) throws -> [Date] {
        guard (1...14).contains(days),
              (1...12).contains(promptsPerDay),
              (0...23).contains(startHour),
              (0...23).contains(endHour),
              endHour > startHour else {
            throw ReminderScheduleError.invalidSettings
        }

        var dates: [Date] = []
        let today = calendar.startOfDay(for: now)

        for dayOffset in 0..<days {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }

            // Calendar triggers contain local clock components, so use each minute only once.
            // Choosing the first repeated time avoids a future date whose trigger resolves to
            // the already-past first occurrence. Strict matching also skips nonexistent minutes.
            let candidates = ((startHour * 60)..<(endHour * 60)).compactMap { clockMinute -> Date? in
                let hour = clockMinute / 60
                let minute = clockMinute % 60
                guard let candidate = calendar.date(
                    bySettingHour: hour,
                    minute: minute,
                    second: 0,
                    of: day,
                    matchingPolicy: .strict,
                    repeatedTimePolicy: .first,
                    direction: .forward
                ),
                calendar.isDate(candidate, inSameDayAs: day),
                calendar.component(.hour, from: candidate) == hour,
                calendar.component(.minute, from: candidate) == minute,
                candidate > now else { return nil }
                return candidate
            }

            let dailyTimes = candidates
                .shuffled()
                .prefix(promptsPerDay)
                .sorted()
            let remainingCapacity = maximumPendingRequests - dates.count
            dates.append(contentsOf: dailyTimes.prefix(remainingCapacity))
            if dates.count == maximumPendingRequests { break }
        }

        guard !dates.isEmpty else { throw ReminderScheduleError.noFutureTimes }
        return dates
    }
}

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let identifierPrefix = "randfit_"
    private var isUpdating = false

    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    func scheduleRandomPrompts(
        days: Int = 14,
        promptsPerDay: Int = 4,
        startHour: Int = 6,
        endHour: Int = 19,
        soundFileName: String? = nil,
        allowedDifficulties: Set<Difficulty>,
        beginnerFriendly: Bool
    ) async throws -> ReminderScheduleResult {
        guard !isUpdating else { throw ReminderScheduleError.alreadyUpdating }
        isUpdating = true
        defer { isUpdating = false }

        // Validate before removing the existing queue.
        guard !allowedDifficulties.isEmpty else { throw ReminderScheduleError.invalidSettings }
        let dates = try ReminderSchedulePlanner.dates(
            days: days,
            promptsPerDay: promptsPerDay,
            startHour: startHour,
            endHour: endHour
        )
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized ||
              settings.authorizationStatus == .provisional ||
              settings.authorizationStatus == .ephemeral else {
            throw ReminderScheduleError.notificationsDisabled
        }

        await removeExistingPrompts()
        var scheduledCount = 0

        for (index, date) in dates.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "RanDoFit — Round Bell"
            content.body = "Ding-ding: \(PromptGenerator.promptLine(allowedDifficulties: allowedDifficulties, beginnerFriendly: beginnerFriendly))"
            if let soundFileName {
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundFileName))
            } else {
                content.sound = .default
            }

            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(identifierPrefix)\(index)",
                content: content,
                trigger: trigger
            )

            do {
                try await center.add(request)
                scheduledCount += 1
            } catch {
                throw ReminderScheduleError.schedulingFailed(scheduled: scheduledCount, requested: dates.count)
            }
        }

        // The planner rejects an empty queue before any existing reminders are removed.
        guard let lastDate = dates.last else { throw ReminderScheduleError.noFutureTimes }
        return ReminderScheduleResult(scheduledCount: scheduledCount, lastScheduledDate: lastDate)
    }

    func clearScheduledPrompts() async throws {
        guard !isUpdating else { throw ReminderScheduleError.alreadyUpdating }
        isUpdating = true
        defer { isUpdating = false }
        await removeExistingPrompts()
    }

    private func removeExistingPrompts() async {
        let pending = await center.pendingNotificationRequests()
        let identifiers = pending.map(\.identifier).filter { $0.hasPrefix(identifierPrefix) }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
