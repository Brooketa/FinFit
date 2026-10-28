# FinFit — Project Overview

FinFit is an iPhone app built with SwiftUI.

This document describes **what is built**, and nothing else. It is the only project-specific rule
file; the other four are shared across projects.

---

## The screens

There are no feature screens yet. The app launches to an empty root screen inside the app's
`NavigationStack`.

Each screen's behaviour is specified in its module's `Docs/` folder.

---

## Rules in force

- iPhone only, portrait only.

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
