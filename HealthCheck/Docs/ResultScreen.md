# Result Screen

The last screen of the health-check flow. It is pushed onto the app's navigation stack, so it has a back button to
the screen before it.

| Part | Content |
|---|---|
| Ring | The circular progress bar, showing the score out of 100 |
| Title | The score category's title, centered, `headingLarge` in `textPrimary` |
| Subtitle | The score category's subtitle, centered, `bodyMedium` in `textSecondary` |
| Finish button | Primary `ActionButton` titled "Finish" |
| Retake button | Secondary `ActionButton` titled "Retake" with the leading `retake` image |

- **Layout:** the ring, title and subtitle stack at the top, 24pt below the safe area, with 32pt between the ring and
  the title and 12pt between the title and the subtitle. The buttons are pinned to the bottom of the safe area, 12pt
  apart and 16pt below the content above them. Everything has 24pt side padding on a `background` fill
- **Score:** a fixed placeholder score of 78, so the screen always shows the Excellent category
- **Finish:** tapping the button does nothing yet
- **Retake:** tapping the button does nothing yet

## Score categories

The score, from 0 to 100, falls into one of four equal categories, which sets the title and subtitle.

| Category | Score | Title | Subtitle |
|---|---|---|---|
| Poor | below 25 | Just starting out | Small steps now go a long way. |
| Fair | 25–49 | Making progress | Good start, some gaps worth closing. |
| Good | 50–74 | Solid ground | Good habits, small gains still available. |
| Excellent | 75 and above | Excellent shape | Strong savings, low debt, solid planning. |

## Components

### Circular progress bar

A ring that shows a progress value from 0 to 1 as a percentage.

| Part | Content |
|---|---|
| Track | A full ring in `primarySubtle` |
| Fill | An arc in `primary` over the track, starting at 12 o'clock and running clockwise in proportion to the progress, with square ends |
| Percentage | The progress as a whole percentage, rounded, e.g. "78" for 0.78, centered in the ring, `headingExtraLarge` in `textPrimary` |
| Maximum | "/100", 4pt below the percentage, `bodyMedium` in `textSecondary` |

- **Size:** fills the largest square its frame allows, up to 240×240pt; the 20pt stroke sits inside that square
- **Range:** values below 0 draw an empty ring showing 0, and values above 1 a full ring showing 100
- **Changes:** a new value is drawn immediately, without animating
