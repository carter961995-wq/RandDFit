# Repair notes — October 17, 2026

## Starting point

Source: `cursor/app-launch-setup-4188` at `d0ef338598c0980ce112417d1118a3539ee0b1e8`. This complete snapshot includes the workout app, illustrations and actual icon bitmaps. It has not been tied to the current App Store archive.

## Problems identified

- Settings did not publish changes, risking an onboarding screen that failed to update.
- Removing the final difficulty silently restored all difficulties, including Hard.
- Reminder scheduling ignored errors and could attempt 168 notifications while reporting unconditional 14-day success.
- The home layout could clip on small screens or at larger text sizes.
- A conditional foreground style mixed incompatible types.
- UserDefaults was used without a required-reason privacy manifest.
- Onboarding claimed one-minute workouts although some generated holds last longer.
- The App Store privacy URL returned 404 because GitHub Pages was disabled.

## Completed local work

Settings now publish changes while retaining existing storage keys. Empty or invalid difficulty choices stay conservative. The reminder planner validates settings, uses future-only unique times, caps its queue at 64, and reports actual count/date or errors. The app prevents overlapping reminder changes and provides a clear-reminders control. The home screen scrolls, conditional style types are corrected, and duration wording is accurate.

The Xcode project includes a required-reason privacy manifest and a shared RandDFit scheme. Eight focused unit tests cover settings persistence/publication, migration, difficulty safety and schedule bounds. The existing icon generator now emits an opaque RGB default icon using its original gradient; dark/tinted icons are unchanged. Static privacy/support pages, App Store copy and handover instructions are included.

## Actual validation and publication status

- Source/project membership, XML/plist structure, scheme target references and asset references checked.
- Default icon verified as 1024×1024 RGB; its appearance was inspected and compared to the original artwork composited onto its native gradient.
- A build-and-test GitHub Actions workflow is prepared with read-only repository permissions and a standard macOS runner.
- **Xcode build and unit-test results are pending.** Swift/Xcode are absent locally; the prepared macOS workflow will provide the actual validation result after the repairs are pushed.
- Repository access was restored on October 17, 2026 (America/Chicago). The earlier connection allowlist blocker is resolved.
- **GitHub Pages is disabled.** The prepared privacy/support files are not yet live, and the existing privacy URL remains broken.
- **No App Store release was submitted.** The production source/archive match is still required.

The repairs use the exact GitHub baseline tree `c5aca32030344e62c26e0403473ea66c4bbd4be8`. Update these statuses after a real macOS build, Pages publication and release verification.

## Remaining release checks

Match the production source/archive and bundle ID; verify on-device behavior; obtain App Store Connect metrics; publish the privacy/support site; prepare a signed release only after these checks.
