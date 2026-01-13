//  SnapshotHelper.swift
//
//  Adapted from fastlane's snapshot helper template.
//  This file enables `snapshot("name")` calls inside UI tests when running via fastlane.

import XCTest

var app: XCUIApplication!

func setupSnapshot(_ app: XCUIApplication) {
    Snapshot.setupSnapshot(app)
}

func snapshot(_ name: String, timeWaitingForIdle timeout: TimeInterval = 20) {
    Snapshot.snapshot(name, timeWaitingForIdle: timeout)
}

final class Snapshot: NSObject {
    static var isEnabled: Bool {
        return ProcessInfo.processInfo.environment["FASTLANE_SNAPSHOT"] == "YES"
    }

    static func setupSnapshot(_ app: XCUIApplication) {
        guard isEnabled else { return }

        // The `-AppleLanguages` / `-AppleLocale` arguments will be injected by fastlane snapshot.
        app.launchArguments += ["-ui_testing"]

        // These env vars are set by fastlane snapshot.
        if let path = ProcessInfo.processInfo.environment["SNAPSHOT_RESULTS_BUNDLE_PATH"] {
            app.launchEnvironment["SNAPSHOT_RESULTS_BUNDLE_PATH"] = path
        }
    }

    static func snapshot(_ name: String, timeWaitingForIdle timeout: TimeInterval = 20) {
        guard isEnabled else { return }

        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(value: true), object: nil)
        _ = XCTWaiter.wait(for: [expectation], timeout: timeout)

        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        XCTContext.runActivity(named: "snapshot: \(name)") { activity in
            activity.add(attachment)
        }
    }
}

