# FinFit

The iOS client for the Peaks **Financial Health Check**: a server-driven questionnaire that ends in a score
and a category. Built with SwiftUI on a modular, Clean Architecture codebase.

## How to run

1. Open `FinFit.xcodeproj` in **Xcode 26** or later.
2. Select the `FinFit` scheme and an iPhone simulator running iOS 26.
3. Run (⌘R). Swift Package Manager resolves Factory on the first build.

Tests: ⌘U.

## What's built

The whole flow, against the live API:

| Screen | Does |
|---|---|
| Intro | Starts a health check, or offers to continue the unfinished one |
| Continue session | Shown when the user has an unfinished health check. They can continue it from the question they left off at, or discard it and start a new one |
| Questionnaire | Shows the server's questions one at a time (single choice, multiple choice and number) with validation, progress, transitions and error recovery |
| Result | Shows the result of the questionnaire: the user's financial health score and what it means |

Each screen's behaviour is specified in `HealthCheck/Docs/`, and every shared package has a spec in its own `Docs/`.

## Where I focused

- **Planning**\
  Every feature was written up as a Jira epic and split into tasks with a clear scope, so the work was
  planned up front and implementation could focus on building one well-defined piece at a time.
- **Foundation**\
  The module structure, architecture and design system were set up before any screen, so every
  screen after them was built the same way, on the same building blocks.
- **UI and UX**\
  A navigation flow that makes sense at every step, and animations that show the user what is going
  on: a subtle breathing logo on the Intro screen, transitions from one question to the next, and the score filling
  the ring on the Result screen. Every animation highlights a change the user should notice.
- **Tests**\
  A highly modular architecture with every dependency behind a protocol, so each layer can be swapped for a
  mock and tested on its own.

## Architecture

The app target is thin: the entry point, the root `NavigationStack`, the router and the dependency wiring. Everything
else lives in local Swift packages, referenced directly in the project file:

| Package | Holds | Depends on |
|---|---|---|
| `Core` | `UserDefaultsService`, small Foundation helpers | None |
| `CoreUI` | The design system: palette, typography, spacing, radii, layout helpers and components (`ActionButton`, `TextInput`, `SingleSelectGroup`, `MultiSelectGroup`, `ProgressBar`, `ViewState`) | None |
| `Networking` | `BaseNetworkClient` over `URLSession`, `Endpoint`, `APIError` | None |
| `HealthCheck` | The four screens, the questionnaire data stack, the session store and the module's routing protocol | `Core`, `CoreUI`, `Networking` |

Inside `HealthCheck`, each screen is a View and a Presenter, and gets only the layers below it that have a job:

```
QuestionnaireView → QuestionnairePresenter → QuestionnaireUseCase → QuestionnaireRepository
                                           ↘ SessionStore             → QuestionnaireDataSource
                                                                       → QuestionnaireNetworkClient
                                                                       → BaseNetworkClient
```

### Key decisions

- **Modules with a strict dependency direction.** Features never import each other and lower modules never import
  higher ones. It keeps the design system reusable and the feature deletable, and makes build boundaries match
  ownership boundaries.
- **Data flows up through three layers.** It starts in the data layer (client and data source), passes through the
  domain layer (repository and use case), and is converted into the presentation layer's models that views use. Each
  layer has its own models, so API changes stop at the data layer.
- **Views never see domain models.** Presenters build each view's `Model` from plain values and get `Action`s back, so
  views are passive and presenters are unit-testable without SwiftUI.
- **Centralized navigation.** One router in the app target owns the navigation stack. Each module declares its own
  route destinations, and the router conforms to them, so modules never navigate or know about each other.
- **Dependency injection with Factory.** Every dependency is passed in through the initializer behind a protocol, so
  each layer can be tested in isolation against fakes and swapped without touching its neighbours. Every module
  keeps its registrations in its own `Module+Factory.swift`, so there is always one place to look to see what a module
  provides, and removing a module takes its registrations with it.
- **Design system first.** Every color, text style, spacing and radius from Figma is a token in `CoreUI`, and the
  components are built on them. Feature code never uses raw colors or magic numbers.
- **Swift 6 strict concurrency.** Presenters and the router are `@MainActor`; everything below is `Sendable`.

### Surviving a force quit

The server already keeps the session; the client only has to remember the **session id**. `SessionStore` saves it
in `UserDefaults` (through Core's `UserDefaultsService`) once the server has accepted the first answer, and removes
it when the session completes. On the next launch, Start sees the saved id and offers **Continue** or **Start over**;
continuing posts the same id and the server returns the current question.

## Assumptions and trade-offs

- **The id is saved after the first answer, not when the session starts.** A session abandoned before answering
  anything has nothing to resume, so offering to continue it would be noise.
- **Every question needs an answer**, even one the server marks as not required. The API has no way to send "no
  answer" for a question, so skipping isn't possible without guessing at the server's behaviour.
- **The category comes from the server.** The client shows what it is sent and never derives it from the score.
- **Missing validation limits are filled in sensibly:** a multiple-choice question allows 1 (or 0 if optional) up to
  all of its options; a number question without `min` or `max` is unbounded on that side. Number input accepts
  decimals in the user's locale; whole numbers are sent without a decimal point.
- **One error screen for every failure.** Whatever goes wrong while loading or submitting (offline, a 4xx or 5xx, an
  unreadable response), the user gets **Try again** (same session) or **Start a new session**. The specific API error
  codes aren't shown: none of them is something the user can fix by reading it, and the two recovery paths cover them
  all. Starting a new session only drops the saved one once the server has accepted the new one, so a failure there
  loses nothing.
- **No going back to an answered question.** The API only accepts an answer to the current question, so back leaves
  the questionnaire for the Intro screen; the session is kept and can be continued.
- **Light mode, portrait, iPhone only**, matching the design. Text uses fixed sizes; Dynamic Type and VoiceOver are
  not done (see below).

## Testing

The architecture is what makes testing easy. Every module is self-contained and every dependency sits behind a
protocol, so any layer can be swapped for a mock. Services, use cases, repositories, data sources and clients are
each tested on their own, against mocks of whatever sits below them.

113 tests in Swift Testing, one target per package plus the app's router tests, all in the `FinFit` scheme:

- every layer of the questionnaire stack (client, decoded from captured API responses in JSON fixtures, data
  source, repository and use case), each against fakes of the layer below;
- the session store, on a throwaway `UserDefaults` suite;
- every presenter, including answer validation, submission, errors and retry;
- `BaseNetworkClient` with a stubbed `URLProtocol`, `UserDefaultsService`, and `AppRouter`.

`CoreUI` holds only tokens and views and has no unit tests; the screens were verified by running the app.

## What I would do next

In order of value to the user:

1. **Accessibility**: VoiceOver labels and traits on the custom components, and Dynamic Type for the text styles.
   It's the biggest gap for real users, and it touches the design system rather than the feature.
2. **Better error handling**: tell failures apart and recover where possible: watch the connection with
   `NWPathMonitor` and retry automatically when it returns, instead of waiting for Try again.
3. **More animation and clearer states**: the flow works, but it could feel better. More animation through the
   flow, and some screens should say more about what is happening.
4. **Haptic feedback** when a retry fails, so the unchanged error screen doesn't read as nothing happening.
5. **UI tests** for the happy path and resume-after-force-quit, against a stubbed server.

## Libraries

**[Factory](https://github.com/hmlongco/Factory) 3.5.1** is the only dependency. It gives compile-time-checked,
per-module registrations with little ceremony, works with `@Observable` presenters through `@InjectedObservable`, and
supports `promised()` registrations, which is exactly what a feature module needs for a router it can't see.
Everything else (networking, persistence, the design system) is plain Foundation and SwiftUI; none of it needed a
library.

## Tools and workflow

- **Claude Code**: writing and reviewing code
- **Jira**: planning and tracking work
- **Figma**: the design system and screens

Every feature was planned in Jira as an epic and split into tasks. Each epic has a feature branch off `develop`.
Each task is built on its own branch off the epic's branch and merged back into it through its own pull request;
once the epic is done, its branch is merged into `develop`. Claude Code worked to the rules checked into this
repository: `CLAUDE.md` is the entry point, and `.claude/rules/` holds the code style, architecture, project
structure and workflow.

| | Example |
|---|---|
| Epic branch | `feat/OFN-100-questionnaire` |
| Task branch | `feat/OFN-123-questionnaire-number-input` |
| Commit | `feat(HealthCheck)[OFN-123]: Added number input to the questionnaire` |

## Time spent

About 10-12 hours, spread over two days (29-30 October 2026).
