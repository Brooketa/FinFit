# Questionnaire Screen

The screen of the health-check flow that asks the questions. The Intro screen's Start button pushes it onto the
app's navigation stack.

## Loading

Opening the screen starts a new session with a fresh id and shows a centered spinner in `primary` until the server
sends the first question. If the request fails, or the session comes back already completed, the spinner stays.

## Question

| Part | Content |
|---|---|
| Progress bar | The full-width `ProgressBar`, filled to the current question's number out of the session's total |
| Title | The question's title, leading-aligned, `headingSmall` in `textPrimary` |
| Description | The question's description, when it has one, `bodyMedium` in `textSecondary` |
| Answers | Depend on the question's type (see below) |
| Next button | Primary `ActionButton` titled "Next" with the trailing `arrow_right` image |

- **Layout:** the progress bar sits at the top of the safe area, under the navigation bar. Below it, the title and
  description stack 24pt down, with 12pt between them, and the answers follow 32pt below. They scroll when they
  don't fit. The Next button is pinned to the bottom of the safe area, 16pt below the content above it. Everything
  except the progress bar has 24pt side padding on a `background` fill
- **Next:** enabled only while the answer is acceptable (see below); disabled, it dims to half opacity. Tapping it
  does nothing yet
- **Back:** the navigation bar's system back button returns to the Intro screen

## Answers by question type

| Type | Answers | Next is enabled when |
|---|---|---|
| Single choice | The options in a `SingleSelectGroup`, none selected at first. Tapping an option selects it and replaces any earlier choice | An option is selected, or the question is optional |
| Multiple choice | The options in a `MultiSelectGroup`, none checked at first. Tapping an option checks or unchecks it; once as many are checked as the question allows, further options don't check | The number checked is within the question's limits |
| Number | A `TextInput` with the placeholder "Enter a number" and a decimal keyboard | The text is a number within the question's range, or the field is empty and the question is optional |

When the question has no selection limits, a required multiple-choice question needs at least one option checked,
and up to all of them can be. A number question without a minimum or maximum is unbounded on that side.

A typed number outside the range outlines the field in the error color, with a message below it, which names the
limits in the user's number format:

| Limits | Message |
|---|---|
| Minimum and maximum | "Enter a number between {minimum} and {maximum}" |
| Minimum only | "Enter a number of at least {minimum}" |
| Maximum only | "Enter a number of at most {maximum}" |
