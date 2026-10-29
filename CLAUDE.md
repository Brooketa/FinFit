# CLAUDE.md

This file is the entry point for understanding this project's rules and conventions.
Read the relevant document before writing, reviewing, or modifying any code.

---

## Rules Index

| Topic             | File                                    | What's covered                                                                                      |
|-------------------|-----------------------------------------|-----------------------------------------------------------------------------------------------------|
| Project Overview  | `.claude/rules/project-overview.md`     | What the app is, its screens, rules in force, testing policy, Jira board, technical notes           |
| Code Style        | `.claude/rules/code-style.md`           | Naming, spacing, comments, types, closures, access control, control flow, SwiftUI colors and layout |
| Architecture      | `.claude/rules/architecture.md`         | Layers (only what's needed), dependency injection with Factory, navigation, model mapping           |
| Project Structure | `.claude/rules/project-structure.md`    | Module tiers, local packages in the project file, module internals, component scoping, localization |
| Workflow          | `.claude/rules/workflow.md`             | Planning before acting, reuse, feature specs, tests, agent skills, deferred work, Jira, Git         |

`project-overview.md` is the only project-specific document. The other four are portable — copying
`.claude/rules/` into a new project means rewriting `project-overview.md` and the module map below,
and nothing else.

---

## Module Map

| Location | Tier | Holds | Depends on |
|---|---|---|---|
| `CoreUI/` | CoreUI | `Palette`, `TextStyle`, `Spacing`, `CornerRadius`, alignment and padding helpers, `ActionButton`, `TextInput` | — |
| `Core/` | Core | `Bundle.marketingVersion` | — |
| `FinFit/App/` | App target | `FinFitApp` (entry point, creates and registers the router), `RootView`, `AppRouter`, `DependencyInjection/Container+Routing.swift` | All packages |

Swift 6 language mode, iOS 26, iPhone, portrait. Factory 3.5.1 is the only third-party dependency.

Tiers are defined in `project-structure.md`. Each module's behaviour is specified in its `Docs/`
folder. Planned and deferred work is on the Jira board.
