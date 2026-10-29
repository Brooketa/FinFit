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

Each screen's behaviour is specified in its module's `Docs/` folder.

---

## Rules in force

- iPhone only, portrait only.
- Light mode only: the app sets its interface style to Light, and every color set in `CoreUI` has a
  single appearance.

---

## Testing

No testing policy has been set. Ask before writing any tests.

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

- DEBUG-only launch arguments: none
