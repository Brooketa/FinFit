# FinFit

An iPhone app built with SwiftUI on a modular, Clean Architecture codebase.

## What's inside

| Path | Holds |
|---|---|
| `CLAUDE.md` | Entry point: rules index and module map |
| `.claude/rules/` | Code style, architecture, project structure, workflow and the project overview |
| `.claude/skills/` | Vendored agent skills, pinned to the Swift and library versions in use (`.claude/skills-vendor/sync-skills.sh` refreshes them) |
| `FinFit.xcodeproj`, `FinFit/` | The app target: entry point, root view, router, routing registration |
| `Core/` | Non-UI foundation package |
| `CoreUI/` | Design system package: palette, typography, spacing, layout helpers, components |

Swift 6 language mode, iOS 26, iPhone, portrait. [Factory](https://github.com/hmlongco/Factory)
3.5.1 is the only third-party dependency. Local packages are referenced directly in the project
file — there is no workspace.

## Jira

Work is tracked on the **OnlyFunds** board, project `OFN`: <https://thorssons.atlassian.net/browse/OFN>.

## Branches

`main` holds released code; work branches off `develop` as `<type>/OFN-<N>-<title>`. See
`.claude/rules/workflow.md`.
