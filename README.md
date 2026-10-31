<img src="FinFit/Assets.xcassets/AppIcon.appiconset/AppIcon.png" alt="FinFit app icon" width="128">

# FinFit

The iOS client for the Peaks **Financial Health Check**: a server-driven questionnaire that ends in a score
and a category. Built with SwiftUI on a modular, Clean Architecture codebase.

## How to run

1. Open `FinFit.xcodeproj` in **Xcode 26** or later.
2. Select the `FinFit` scheme and an iPhone simulator running iOS 26.
3. Run (⌘R). Swift Package Manager resolves Factory on the first build.

Tests: ⌘U.

## What's built

| Screen | Does |
|---|---|
| Intro | Starts a health check, or offers to continue the unfinished one |
| Continue session | Shown when the user has an unfinished health check. They can continue it from the question they left off at, or discard it and start a new one |
| Questionnaire | Shows the server's questions one at a time (single choice, multiple choice and number) with validation, progress, transitions and error recovery. Asks before leaving a session in progress |
| Result | Shows the result of the questionnaire: the user's financial health score and what it means |

<table>
  <tr>
    <td align="center" width="33%"><img src="Screenshots/intro.png" alt="Intro screen" width="260"><br>Intro</td>
    <td align="center" width="33%"><img src="Screenshots/continue_session.png" alt="Continue session screen" width="260"><br>Continue session</td>
    <td align="center" width="33%"><img src="Screenshots/questionnaire_number.png" alt="Questionnaire: number screen" width="260"><br>Questionnaire: number</td>
  </tr>
</table>

<table>
  <tr>
    <td align="center" width="33%"><img src="Screenshots/questionnaire_single_choice.png" alt="Questionnaire: single choice screen" width="260"><br>Questionnaire: single choice</td>
    <td align="center" width="33%"><img src="Screenshots/questionnaire_multiple_choice.png" alt="Questionnaire: multiple choice screen" width="260"><br>Questionnaire: multiple choice</td>
    <td align="center" width="33%"><img src="Screenshots/result.png" alt="Result screen" width="260"><br>Result</td>
  </tr>
</table>

## Where I focused

- **Planning**\
  Features were organized into Jira epics and smaller tasks with clear scopes, making implementation easier to manage.
- **Foundation**\
  The architecture, modules and design system were established before building screens to ensure consistency across
  the app.
- **UI and UX**\
  I focused on making the app intuitive, with purposeful animations, smooth navigation and session recovery. The
  animated score reveal also builds anticipation and makes the final result more rewarding.
- **Tests**\
  Dependencies are defined through protocols, allowing each layer to be mocked and tested independently.

## Architecture

I chose Clean Architecture for two reasons:

- **Separation of concerns**\
  Each layer has one job, so when building a feature it is always clear what goes where.
- **Testability**\
  Each layer can be unit tested on its own, against mocks of the layer below.

The code is organized into three layers, each with its own responsibilities and models.

| Layer | Holds |
|---|---|
| Presentation | View and Presenter |
| Domain | Use case and Repository |
| Data | Data source and Client |

For the Questionnaire screen:

```
QuestionnaireView → QuestionnairePresenter → QuestionnaireUseCase → QuestionnaireRepository
                                           ↘ SessionStore             → QuestionnaireDataSource
                                                                       → QuestionnaireNetworkClient
                                                                       → BaseNetworkClient
```

The code is split into local Swift packages:

| Package | Holds | Depends on |
|---|---|---|
| `Core` | `UserDefaultsService`, small Foundation helpers | None |
| `CoreUI` | The design system: palette, typography, spacing, radii, layout helpers and components (`ActionButton`, `TextInput`, `SingleSelectGroup`, `MultiSelectGroup`, `ProgressBar`, `ViewState`) | None |
| `Networking` | `BaseNetworkClient` over `URLSession`, `Endpoint`, `APIError` | None |
| `HealthCheck` | The whole health-check flow: the Intro, Continue session, Questionnaire and Result screens, the questionnaire data stack, the session store and the module's routing protocol | `Core`, `CoreUI`, `Networking` |

### Key decisions

- **Strict module dependencies**\
  Features never import each other, and lower-level modules never depend on higher-level ones. This keeps modules
  independent, reusable and easy to remove.
- **Views never see domain models**\
  Presenters convert data into view-specific `Model`s and handle `Action`s, keeping views passive and presenters
  testable without SwiftUI.
- **Centralized navigation**\
  A single router in the app target manages navigation. Modules declare their destinations without knowing about
  each other.
- **Dependency injection with Factory**\
  Dependencies are injected through protocols, making them easy to replace or mock. Each module manages its
  registrations in `Module+Factory.swift`.
- **Design system first**\
  Colors, typography, spacing and radii are defined as tokens in `CoreUI`. Features use these tokens instead of
  hardcoded values.
- **Swift 6 strict concurrency**

### Surviving a force quit

The server manages sessions, so the app only needs to persist the session ID. `SessionStore` saves it in
`UserDefaults` after the first successful answer and removes it when the session is completed or discarded.

Users can continue their session whenever they return to the questionnaire, whether they leave the app, close it, or
navigate away. Continuing sends the saved ID to the server, which returns the question user stopped at.

## Assumptions and trade-offs

- **Answers cannot be changed**\
  The API only accepts answers to the current question, so users cannot go back and correct previous answers. This
  is a limitation of the current flow, as a wrong answer cannot be corrected without starting a new session.
- **A session starts with the first answer**\
  Sessions are only saved after the first answer, avoiding unnecessary recovery prompts for questionnaires opened but
  never started.
- **Score categories are fixed in the app**\
  The app defines the four categories and their descriptions. New categories require an app update. Ideally, the
  backend would provide these descriptions.
- **Validation follows the backend**\
  Selection limits and numeric ranges come from the API. Missing rules are treated as unrestricted rather than
  introducing arbitrary limits.
- **Simple error handling**\
  All failures show the same error screen with Try again and Start a new session. Technical error messages are hidden
  since users cannot act on them. The previous session is only removed after a new one is successfully created.

## Testing

Every module with logic (`Core`, `Networking`, `HealthCheck` and the app target) has its own unit tests, written with
Swift Testing. `CoreUI` only holds design tokens and views, so it has none.

## What I would do next

In order of value to the user:

1. **Going back to change an answer**: keep the answers the user has given and let them step back to an answered
   question, see their answer and change it. Today the API only accepts an answer to the current question, so this
   needs it to accept a changed answer to an earlier one.
2. **Better error handling**: tell failures apart and recover where possible: watch the connection with
   `NWPathMonitor` and retry automatically when it returns, instead of waiting for Try again.
3. **More UI animations**: enhance the user experience with additional animations and transitions to make the app
   feel more polished and engaging.
4. **Haptic feedback** when a retry fails, so the unchanged error screen doesn't read as nothing happening.
5. **UI tests** for the happy path and resume-after-force-quit, against a stubbed server.
6. **Accessibility**: VoiceOver labels and traits on the custom components, and Dynamic Type for the text styles.
   The EU requires it, and it's the biggest gap for real users. Most of the work is in the design system rather
   than the feature.

## Libraries

**[Factory](https://github.com/hmlongco/Factory) 3.5.1** is the only external dependency. It provides type-safe
dependency registration, supports `@Observable` presenters through `@InjectedObservable`, and allows modules to
register dependencies through `promised()` without importing their implementations.

Networking, persistence and UI components use Foundation and SwiftUI without additional libraries.

## Tools and workflow

- **Claude Code**: writing and reviewing code
- **Jira**: planning and tracking work
- **Figma**: the design system and screens

Each feature is planned as a Jira epic with its own branch from `develop`. Tasks have separate branches and pull
requests that merge into the epic branch. Completed epics are merged into `develop`. UI changes include screenshots
or screen recordings in their pull requests.

| | Example |
|---|---|
| Epic branch | `feat/OFN-100-questionnaire` |
| Task branch | `feat/OFN-123-questionnaire-number-input` |
| Commit | `feat(HealthCheck)[OFN-123]: Added number input to the questionnaire` |

Each module has a `Docs/` folder with specifications describing its functionality and behavior. Feature modules
have one specification per screen, while other modules have one per module. These are maintained alongside the code,
helping new developers understand the project without reading through the implementation.

## Time spent

Approximately **12–13 hours**, spread over three days (29–31 October 2026).

| Activity | Time |
|---|---|
| Planning and Jira task breakdown | 2 hours |
| Development | 6 hours |
| UI/UX improvements (navigation, animations, quality of life) | 2–3 hours |
| Bug fixing | ~1 hour |
| PR screenshots and screen recordings | ~1 hour |
| **Total** | **12–13 hours** |
