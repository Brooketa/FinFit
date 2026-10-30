# Intro Screen

The first screen of the health-check flow, and the screen the app launches to. It sits at the root of the app's
navigation stack.

| Part | Content |
|---|---|
| Logo | A 180pt `primarySubtle` circle holding a 120pt circle with a leading-to-trailing gradient from `primary` to `darkBackground` and a soft shadow below it; the white trending-up `intro_logo_symbol` image sits in the center |
| Title | "How healthy are your" and "finances?" on two lines, centered, `headingLarge` in `textPrimary` |
| Subtitle | "5 questions, 2 minutes.", centered, `bodyMedium` in `textSecondary` |
| Start button | Primary `ActionButton` titled "Start" with the trailing `arrow_right` image |

- **Layout:** the logo, title and subtitle stack at the top, 48pt below the safe area, with 48pt between the logo
  and the title and 12pt between the title and the subtitle. The start button is pinned to the bottom of the safe
  area, 16pt below the content above it. Everything has 24pt side padding on a `background` fill
- **Logo animation:** when the screen appears, the gradient circle springs in from 60% to full size over 0.6s,
  and the symbol rises 12pt and fades in over 0.6s, starting 0.15s later. From the same moment, the outer
  `primarySubtle` circle breathes on a loop, easing between full size and opacity and 108% size at 70% opacity over
  1.6s each way. The gradient circle pulses on the same 1.6s loop between full size and 104%, starting 0.4s later,
  so the two never grow and shrink in step. Only size and opacity animate, so the logo never moves and the layout
  around it never changes
- **Start:** tapping the button pushes the Questionnaire screen, on the saved unfinished session if there is one,
  otherwise on a new session
