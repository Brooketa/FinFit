# Result Screen

The last screen of the health-check flow. It is pushed onto the app's navigation stack, so it has a back button to
the screen before it.

- **Content:** none yet; the screen is an empty `background` fill

## Components

### Circular progress bar

A ring that shows a progress value from 0 to 1 as a percentage. It is not placed on the screen yet.

| Part | Content |
|---|---|
| Track | A full ring in `primarySubtle` |
| Fill | An arc in `primary` over the track, starting at 12 o'clock and running clockwise in proportion to the progress, with square ends |
| Percentage | The progress as a whole percentage, rounded, e.g. "78" for 0.78, centered in the ring, `headingExtraLarge` in `textPrimary` |
| Maximum | "/100", 4pt below the percentage, `bodyMedium` in `textSecondary` |

- **Size:** fills the largest square its frame allows, up to 240×240pt; the 20pt stroke sits inside that square
- **Range:** values below 0 draw an empty ring showing 0, and values above 1 a full ring showing 100
- **Changes:** a new value is drawn immediately, without animating
