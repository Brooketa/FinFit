# Continue Session Screen

Lets the user pick up an unfinished health check or start over. The Intro screen's Start button pushes it when a
session is saved (see **Session store** in `QuestionnaireAPI.md`), passing the saved session's id.

| Part | Content |
|---|---|
| Title | "Pick up where you left off", leading-aligned, `headingLarge` in `textPrimary` |
| Subtitle | "You have a financial health check in progress. You can continue or start over.", leading-aligned, `bodyMedium` in `textSecondary` |
| Continue button | Primary `ActionButton` titled "Continue" with the trailing `arrow_right` image |
| Start over button | Destructive `ActionButton` titled "Start over" with the leading `retake` image |

- **Layout:** the title and subtitle stack at the top, 24pt below the safe area, 12pt apart. The buttons are pinned to
  the bottom of the safe area, 12pt apart and 16pt below the content above them. Everything has 24pt side padding on a
  `background` fill
- **Continue:** pushes the Questionnaire screen on the saved session; its back button returns to the Intro screen,
  not here
- **Start over:** removes the saved session and pushes the Questionnaire screen on a new session
- **Back:** the navigation bar's system back button returns to the Intro screen
