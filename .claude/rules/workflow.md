# Workflow Rules

## Planning Before Acting

When asked to fix a bug or implement a feature, always confirm the plan before making any edits. Provide a brief summary of:
- What will change and why
- Which files will be modified or created

Wait for explicit approval before proceeding. (Creating the branch is not an edit and does not wait —
see Git → Starting Work.)

## Architecture Uncertainty

If unsure about the right architectural approach, do not guess and implement. Instead:
- Write out the general idea and the options you are considering
- Explain the trade-offs or unknowns
- Wait for approval or direction before proceeding

## Reusing Existing Code

Before writing a new view, component or helper, search for something that already does the job:
`CoreUI` for design tokens, images, components and view helpers, `Core` for extensions, utilities and
the domain types, stores and data stacks features share, and the module's own `Common/` for what its
screens already share.

## Extending Core / CoreUI

If something is missing from `Core` or `CoreUI` but would logically belong there
(i.e., it will be used across the codebase), do not add it unilaterally. Instead:
- Explain what you want to add and why it belongs there
- Ask for permission
- Wait for approval before making any changes

This includes new design tokens in `CoreUI`.

## Feature Spec Files

Every module has behavioural spec markdown file(s) in its `Docs/` folder, describing how it works. A
module with screens has one spec per screen (`<Module>/Docs/<ScreenName>Screen.md`); a service-only
module has one for the module (`<Module>/Docs/<Module>.md`).

**A spec describes what is built, and nothing else.** No deferred work, no "not built yet" sections,
no future plans, and **no ticket references**. A developer must be able to read it and know what the
app does today. The board is where unbuilt work lives; a spec that mixes the two stops being
trustworthy.

Keep them short and scannable — bullets and tables over prose, and short paragraphs where prose is
needed. A spec is what a developer reads to understand the core of a feature quickly, so describe
*how it behaves*, not how the code is structured.

At the **end of any work that touches a module**, you must:
- **Update the relevant spec file(s)** to reflect the behaviour you changed, added, or removed.
- **Re-check the spec against the implementation**: every statement in it must still be true. If a
  behaviour was intentionally changed, update the spec. If something the spec claims is missing from
  the code, flag it rather than quietly deleting either side.

If a module has no spec file yet and your work meaningfully defines its behaviour, create one in the
same format.

## Tests

The testing policy is project-specific and is stated in `project-overview.md`. Follow it. If the
overview says nothing about tests, ask before writing any.

Whatever the policy, verify work by building, and by running the app where a change is visible.

## Agent Skills

Third-party Claude Code skills are vendored into `.claude/skills/` by `.claude/skills-vendor/` (see its
`README.md`). Never hand-edit a vendored skill.

**A skill must match the version of what it describes.** A skill written for a newer Swift or a newer
library teaches APIs the project cannot use; one written for an older version teaches patterns the
project has moved past. So:

- Pin each skill's `ref` in `skills.manifest.json` to the upstream tag or commit that matches the
  version the project uses — the Factory skill to the Factory release in the project, the Swift skills
  to the project's Swift toolchain and language mode. Do not leave a `ref` on `main`.
- Whenever the project's Swift version or a library with a skill is upgraded, update that skill's `ref`
  and re-run `sync-skills.sh` in the same change.
- If no upstream version matches, say so rather than syncing the nearest one silently.

## Deferred Work

There is no `backlog.md`. Deferred work — a bug found along the way, tech debt, an open question, the
part of a feature left for later — becomes a **Jira ticket**.

But the board is not filled automatically. When something looks like it should be deferred:

1. **Propose it** — a title, its type of work, and a sentence on what and why.
2. **Wait for the developer to confirm** it is worth a ticket.
3. Only then create it, in the ticket format below.

Never create a ticket that was not confirmed. A rejected proposal is simply dropped.

## Jira

Work lives on the project's Jira board. Its key and URL are in `project-overview.md`.

**Every major feature is an Epic** — a screen, or an integration such as RevenueCat subscriptions or
Firebase Analytics. Its tasks build the feature up piece by piece: for a screen, the first task adds
the screen itself and the rest add its components and wire them up. Work items are Tasks, defects
are Bugs.

### Ticket Structure

- **Title** — understandable on its own, in the board's list, by someone who wasn't in the conversation.
- **Description** — what this is and why, clear enough that whoever picks it up can decide what to do.
  A short paragraph or two. No step-by-step implementation.
- **Acceptance criteria** — how we know it's done. Checkable statements, not a restated description.

Leave fine detail out. Paddings, sizes, colours and exact file paths belong in the design handoff and
the screen spec, not in a ticket.

A task is scoped to fit one pull request of **at most 600 lines of code**. Localization catalogs,
asset catalogs and other generated files do not count towards that. Where a component's UI and its
business logic together would exceed it, split them into two tasks; where they comfortably fit, keep
them in one.

### Type Of Work Is A Label

Jira's issue type does not carry the type of work — a refactor and a chore are both a `Task`. So the
type of work is a **label**, spelled exactly as the branch prefix: `feat`, `bugfix`, `chore`,
`refactor`. Every issue carries one, set at creation, and it is what a branch name is built from.
Bugs carry `bugfix` as well as being typed `Bug`.

## Git

### Branches

Work happens on a branch cut from `develop`, never on `develop` itself.

```
<type>/<TICKET-ID>-<title-separated-by-words>
```

| Type of work | Prefix     |
|--------------|------------|
| Feature      | `feat`     |
| Bug          | `bugfix`   |
| Chore        | `chore`    |
| Refactor     | `refactor` |

- `<type>` comes from the ticket's type-of-work label. If it has none, add one before cutting the
  branch; ask only if it can't be inferred.
- `<TICKET-ID>` is the Jira key, uppercase — `ABC-14`. Work with no ticket has no id; it goes straight
  from the prefix to the title.
- `<title-separated-by-words>` is the work's title, lowercased, words separated by hyphens —
  `feat/ABC-14-item-list-presenter-and-routing`, `chore/update-agent-rules`.

### Starting Work

Creating and publishing the branch is **mandatory and automatic** — the first thing Claude does,
before any code edits. This is never a "want me to create the branch?" question and never an
ask-first step; it is a standard part of starting the work.

1. Create the branch off `develop` (`git checkout develop && git pull && git checkout -b <branch>`).
2. Publish it (`git push -u origin <branch>`).
3. Only then begin the actual work.

The push is allowed **only** to create a branch remotely. A branch Claude pushes must carry no new
commits authored by Claude.

### Forbidden

Committing is done by the developer, who wants to review the code first. Claude must never:
- Stage or commit any changes
- Push commits to any branch (publishing an empty new branch to the remote is allowed — see Starting Work)
- Create or modify pull requests, or add/change PR labels and tags

Claude may only create branches (including publishing an empty branch to the remote) and write/modify
files. Leave all other version control actions to the developer.
