# Questionnaire Screen

The screen of the health-check flow that asks the questions. The Intro screen's Start button pushes it onto the
app's navigation stack.

## Loading

Opening the screen resumes the saved session if there is one (see **Session store** in `QuestionnaireAPI.md`), or
starts a new session with a fresh id, and shows a centered spinner in `primary` until the server sends the current
question. Once the server has started the session, its id is saved. If the request fails, the spinner stays and
nothing is saved. If the session comes back already completed, its id is removed and the Result screen opens.

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
- **Next:** enabled only while the answer is acceptable (see below); disabled, it dims to half opacity
- **Submitting:** tapping Next sends the answer to the server. While it is being sent, a spinner replaces the button's
  title and further taps are ignored. The server replies with the next question, which replaces the current one with
  nothing selected, or with the result after the last question
- **Finishing:** once the server returns the result, the Result screen is pushed on top of the questionnaire, showing
  the score and category
- **Submit failure:** the answer stays as it was and Next can be tapped again
- **Back:** the navigation bar's system back button returns to the Intro screen

## Answers by question type

| Type | Answers | Next is enabled when |
|---|---|---|
| Single choice | The options in a `SingleSelectGroup`, none selected at first. Tapping an option selects it and replaces any earlier choice | An option is selected |
| Multiple choice | The options in a `MultiSelectGroup`, none checked at first. Tapping an option checks or unchecks it; once as many are checked as the question allows, further options don't check | At least one is checked, and the number checked is within the question's limits |
| Number | A `TextInput` with the placeholder "Enter a number", a decimal keyboard and the instruction (see below) as its label | The text is a number within the question's range |

Every question needs an answer, including one the server marks as optional. When the question has no selection
limits, up to all of its options can be checked. A number question without a minimum or maximum is unbounded on that
side.

The answer is sent as the selected option's id, the checked options' ids in the order the options are listed, or the
number.

A typed number outside the range outlines the field in the error color, with "Please enter a number within the range above." below it.

## Instruction

A number question with limits shows a line above its field, as the text input's label, telling the user what value it
expects. Numbers are in the user's number format. Choice questions show none.

| Limits | Instruction |
|---|---|
| Minimum and maximum | "Enter a value between {minimum} and {maximum}" |
| Minimum only | "Enter a value of at least {minimum}" |
| Maximum only | "Enter a value of at most {maximum}" |
| Neither | None |
