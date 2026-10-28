# <AppName> — Project Overview

<One paragraph: what the app is and who it is for.>

This document describes **what is built**, and nothing else. It is the only project-specific rule
file; the other four are shared across projects.

---

## The screens

| Screen | What it does |
|---|---|
| **<Screen>** | <One line> |

Each screen's behaviour is specified in its module's `Docs/` folder.

---

## Rules in force

<Product rules that constrain code: orientation, devices, what leaves the device, persistence,
accessibility targets, performance targets.>

---

## Testing

<One of:>
- **There are no tests.** Do not write unit, UI or snapshot tests, and do not offer to. Do not add a
  test target, a test file, or a testing dependency. Verify by building and running the app.
- **Tests are written for <layers>.** <Framework, where test targets live, what must be covered.>

---

## Jira

Board: **<Board name>** — project `<KEY>`, <https://….atlassian.net/browse/KEY>

---

## Technical notes

- Platform and deployment target: <iOS NN, iPhone/iPad, Swift version and language mode>
- Third-party dependencies: Factory, <…>
- Schemes / targets:

  | Scheme | Target | Bundle id | Purpose |
  |---|---|---|---|
  | `<App>` | <App> | `<bundle id>` | Release |
  | `<App> Staging` | <App> Staging | `<bundle id>` | Testing |

- DEBUG-only launch arguments: <…>
