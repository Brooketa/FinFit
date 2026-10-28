# iOS Foundation

A starting point for new iOS apps: a shared ruleset for Claude Code plus a small working Xcode
project that follows it.

## What's inside

| Path | Holds |
|---|---|
| `CLAUDE.md` | Entry point: rules index and module map |
| `.claude/rules/` | Code style, architecture, project structure, workflow, and the per-project overview template |
| `.claude/skills/` | Vendored agent skills, pinned to the Swift and library versions in use (`.claude/skills-vendor/sync-skills.sh` refreshes them) |
| `Starter.xcodeproj`, `Starter/` | The app target: entry point, root view, router, routing registration |
| `Core/` | Non-UI foundation package |
| `CoreUI/` | Design system package: palette, typography, spacing, layout helpers, components |
| `Home/` | Placeholder feature package showing the architecture end to end |

Swift 6 language mode, iOS 26, iPhone, portrait. [Factory](https://github.com/hmlongco/Factory)
3.5.1 is the only third-party dependency. Local packages are referenced directly in the project
file — there is no workspace.

## Starting a new app

1. Create a repo from this template and clone it.
2. Rename the `Starter` target, folder and scheme, and set the bundle identifier and development team.
3. Fill in `.claude/rules/project-overview.md` and the module map in `CLAUDE.md`.
4. Replace `Home/` with the first real feature.

## Branches

`main` holds released code; work branches off `develop` as `<type>/<KEY-N>-<title>`. See
`.claude/rules/workflow.md`.
