# Result Screen

The last screen of the health-check flow. It is pushed onto the app's navigation stack, so it has a back button to
the screen before it.

| Part | Content |
|---|---|
| Ring | The circular progress bar, showing a fixed placeholder result of 0.78 |
| Title | "Solid ground", centered, `headingLarge` in `textPrimary` |
| Subtitle | "Good habits, small gains still available", centered, `bodyMedium` in `textSecondary` |
| Finish button | Primary `ActionButton` titled "Finish" |
| Retake button | Secondary `ActionButton` titled "Retake" with the leading `retake` image |

- **Layout:** the ring, title and subtitle stack at the top, 24pt below the safe area, with 32pt between the ring and
  the title and 12pt between the title and the subtitle. The buttons are pinned to the bottom of the safe area, 12pt
  apart and 16pt below the content above them. Everything has 24pt side padding on a `background` fill
- **Content:** the result, title and subtitle are placeholders; they are the same every time
- **Finish:** tapping the button does nothing yet
- **Retake:** tapping the button does nothing yet

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
