# FinFit — Project Overview

FinFit is an iPhone app built with SwiftUI.

This document describes **what is built**, and nothing else. It is the only project-specific rule
file; the other four are shared across projects.

---

## The screens

The app launches to the `HealthCheck` module's Intro screen, at the root of the app's
`NavigationStack`.

| Screen | Module | Spec |
|---|---|---|
| Intro | `HealthCheck` | `HealthCheck/Docs/IntroScreen.md` |
| Questionnaire | `HealthCheck` | `HealthCheck/Docs/QuestionnaireScreen.md` |
| Continue session | `HealthCheck` | `HealthCheck/Docs/ContinueSessionScreen.md` |
| Result | `HealthCheck` | `HealthCheck/Docs/ResultScreen.md` |

Each screen's behaviour is specified in its module's `Docs/` folder.

---

## Rules in force

- iPhone only, portrait only.
- Light mode only: the app sets its interface style to Light, and every color set in `CoreUI` has a
  single appearance.

---

## Testing

Unit tests use **Swift Testing** (`import Testing`, `@Suite`, `@Test`, `#expect`).

- **What is tested:** every module with logic has its own test target — the services in `Core`, the base network
  client in `Networking`, every layer of the `HealthCheck` data stack, its session store and its presenters, and the
  app's router. `CoreUI` holds tokens and views only and is not unit tested.
- **Where:** a package's tests live in `Tests/<Module>Tests/`, declared as a `.testTarget` in its `Package.swift`, and
  every test target is added to the `FinFit` scheme's test action, so ⌘U and `xcodebuild test -scheme FinFit` run
  them all. The app target's tests live in `FinFitTests/` at the repository root, a unit-test target hosted by the
  app, so they can `@testable import FinFit`. Inside a test target, each subject gets its own folder, `<Subject>Tests/`, holding `<Subject>Tests.swift` and, as
  needed, `Fixtures/`, `Mocks/` and `Models/` (types that exist only for the tests).
- **Shape:** a test is a `final class <Subject>Tests` marked `@Suite("<Subject>")`. Its `init` builds the subject
  and any throwaway resources, its `deinit` cleans them up, and each `@Test("…")` describes the behaviour it checks
  in a sentence.
- **Isolation:** each layer is tested against fakes of the protocol below it. No test talks to the real network or
  to `UserDefaults.standard`; storage tests use a throwaway `UserDefaults` suite, created in `init` and deleted in
  `deinit`.
- **Fixtures:** test data comes from fixtures, one file per type named `<Type>+Fixtures.swift`, holding an
  `extension <Type>` with a `static func fixture(…)` that has a default for every parameter. A test writes
  `.fixture()` and overrides only what it is about. Fixtures used by one subject sit in its `Fixtures/`; fixtures
  shared by several subjects move up to `Tests/<Module>Tests/Fixtures/`.

---

## Jira

Board: **OnlyFunds** — project `OFN`, <https://thorssons.atlassian.net/browse/OFN>

---

## Technical notes

- Platform and deployment target: iOS 26, iPhone, Swift 6 language mode
- Third-party dependencies: Factory 3.5.1
- Schemes / targets:

  | Scheme | Target | Bundle id | Purpose |
  |---|---|---|---|
  | `FinFit` | FinFit | `com.thorssons.finfit` | Development and release |
  | `FinFit` | FinFitTests | `com.thorssons.finfitTests` | Unit tests for the app target, hosted by the app |

- DEBUG-only launch arguments: none
- Launch screen: the `UILaunchScreen` entry in `FinFit/Info.plist` shows the `launch_logo` image (the purple F) centered
  on `launch_background`. Both live in the app target's `Assets.xcassets`, because iOS reads the launch screen only from
  the app bundle; `launch_background` is a copy of CoreUI's `background` (white), so the hand-off to the Intro screen
  doesn't flash. `INFOPLIST_KEY_UILaunchScreen_Generation` is off so the entry isn't replaced by a generated one
- API base URL: the `APIBaseURL` key in `FinFit/Info.plist`, which Xcode merges with the generated Info.plist.
  `Info.plist` is excluded from the `FinFit` folder's target membership so it is not also copied as a resource
