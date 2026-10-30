# Questionnaire Screen

The screen of the health-check flow that asks the questions. The Intro screen's Start button pushes it onto the
app's navigation stack.

| Part | Content |
|---|---|
| Progress bar | The full-width `ProgressBar`, showing how far through the session the user is |
| Title | The question's title, leading-aligned, `headingSmall` in `textPrimary` |
| Description | The question's description, when it has one, `bodyMedium` in `textSecondary` |
| Next button | Primary `ActionButton` titled "Next" with the trailing `arrow_right` image |

- **Layout:** the progress bar sits at the top of the safe area, under the navigation bar. Below it, the title and
  description stack 24pt down, with 12pt between them, and scroll when they don't fit. The Next button is pinned to
  the bottom of the safe area, 16pt below the content above it. Everything except the progress bar has 24pt side
  padding on a `background` fill
- **Question:** a fixed placeholder question, "What are you investing for?" with the description "Select up to three
  goals.", with the progress bar at 20%
- **Next:** tapping the button does nothing yet
- **Back:** the navigation bar's system back button returns to the Intro screen
