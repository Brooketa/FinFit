# CoreUI

The design system every feature draws with.

| Area | Holds |
|---|---|
| `Palette` | The design's colors, each a color set in `Assets.xcassets` with a single, light appearance — see **Colors** below |
| `TextStyle` | The design's type scale on the system font, at fixed sizes; applied with `.textStyle(_:)` — see **Typography** below |
| `Spacing` | The design's spacing scale on a 4pt grid; applied with `.padding(_:)` — see **Spacing** below |
| `CornerRadius` | The design's corner radii — see **Spacing** below |
| Alignment | `alignLeading/Trailing/HorizontalCenter`, `alignTop/Bottom/VerticalCenter`, the four corners and `alignCenter` — each expands the view and pins it |
| `ActionButton` | Full-width capsule button in a primary, secondary or destructive style — see **Buttons** below |
| `TextInput` | Full-width text field with an optional label and prefix, and a normal or error status — see **Text Input** below |
| `SingleSelectGroup`, `RadioListItem` | Single-choice list of option rows, and the row on its own — see **Radio Buttons** below |
| `MultiSelectGroup`, `CheckboxListItem` | Multiple-choice list of option rows, and the row on its own — see **Multi Select** below |
| `ProgressBar` | Full-width bar filled to a progress value from 0 to 1 — see **Progress Bar** below |

## Colors

The app is light-only, so every color has one value.

| Group | Token | Hex | Role |
|---|---|---|---|
| Brand | `primary` | `#6334FF` | Primary buttons, links, selection |
| Brand | `primarySubtle` | `#EEE8FF` | Light tint behind brand content |
| Background | `background` | `#FFFFFF` | Screen background |
| Background | `backgroundSecondary` | `#F5F4FC` | Grouped content on the screen background |
| Background | `backgroundTertiary` | `#E8E6F5` | One step stronger than secondary |
| Background | `surface` | `#FFFFFF` | Cards, inputs, list items |
| Text | `textPrimary` | `#160A34` | Titles and body text |
| Text | `textSecondary` | `#695F91` | Captions, hints, metadata |
| Text | `textTertiary` | `#A29BC8` | Placeholders, disabled labels |
| Text | `textOnPrimary` | `#FFFFFF` | Text on a `primary` fill |
| Text | `textOnDark` | `#FFFFFF` | Text on a `darkBackground` or `selected` fill |
| Border & icon | `border` | `#DAD7EE` | Default outlines and dividers |
| Border & icon | `borderStrong` | `#A29BC8` | Higher-contrast outlines |
| Border & icon | `iconPrimary` | `#160A34` | Icons at full emphasis |
| Border & icon | `iconSecondary` | `#695F91` | Icons at reduced emphasis |
| Status | `success` | `#00DC82` | Positive outcomes |
| Status | `warning` | `#FFBE00` | Cautions |
| Status | `error` | `#FF2D75` | Errors, destructive actions |
| Status | `info` | `#007AFF` | Neutral information |
| Dark & selection | `darkBackground` | `#1E0F44` | Dark, high-emphasis areas |
| Dark & selection | `selected` | `#261452` | Fill of a selected item |
| Dark & selection | `selectedSubtle` | `#F3EEFF` | Light fill behind a selected item |

## Typography

Every style uses the system font at a fixed size. Tracking is a percentage of the font size.

| Token | Weight | Size | Tracking | Use |
|---|---|---|---|---|
| `headingExtraLarge` | Bold | 48 | −2% | Largest display heading |
| `headingLarge` | Bold | 36 | −1.5% | Screen titles |
| `headingMedium` | Bold | 30 | −1% | Prominent headings |
| `headingSmall` | Semibold | 24 | −0.5% | Section headings |
| `headingExtraSmall` | Semibold | 20 | −0.3% | Small headings |
| `bodyLarge` | Regular | 16 | 0 | Body text |
| `bodyMedium` | Regular | 14 | 0 | Secondary body text |
| `bodySmall` | Regular | 12 | 0 | Captions |
| `bodyLargeMedium` | Medium | 16 | +0.2% | Emphasised body text, button labels |
| `bodyMediumMedium` | Medium | 14 | +0.2% | Emphasised secondary text |
| `bodySmallMedium` | Medium | 12 | +0.2% | Emphasised captions |

## Spacing

| Token | Figma | Value |
|---|---|---|
| `Spacing.extraSmall` | `xs` | 4 |
| `Spacing.small` | `sm` | 8 |
| `Spacing.medium` | `md` | 12 |
| `Spacing.large` | `lg` | 16 |
| `Spacing.extraLarge` | `xl` | 20 |
| `Spacing.extraLarge2` | `2xl` | 24 |
| `Spacing.extraLarge3` | `3xl` | 32 |
| `Spacing.extraLarge4` | `4xl` | 48 |
| `Spacing.extraLarge5` | `5xl` | 64 |
| `CornerRadius.small` | — | 8 |
| `CornerRadius.medium` | `radius/md` | 12 |
| `CornerRadius.large` | — | 16 |

## Buttons

`ActionButton` takes a localized title, a `Style`, an optional leading and trailing `Image`, and an action.
It fills the available width and is at least 60pt tall, growing if its title wraps.

| Style | Fill | Outline | Title and icons | Use |
|---|---|---|---|---|
| `primary` | `primary` | — | `textOnPrimary` | The main action on a screen |
| `secondary` | `background` | 1.5pt `primary` | `primary` | An alternative action |
| `destructive` | `error` | — | `textOnPrimary` | Deleting, or an action that can't be undone |

- **Layout:** capsule shape, 32pt horizontal padding, 8pt between icons and title, 24pt icons, title in `bodyMediumMedium`
- **Pressed:** the whole button drops to 80% opacity
- **Disabled:** set with `.disabled(_:)`; the whole button drops to 50% opacity and ignores taps
- **VoiceOver:** reads the title as a button; icons are hidden from it

## Text Input

`TextInput` edits a `String` binding and takes a localized placeholder, plus an optional localized label, an
optional `String` prefix and a `Status`: `.normal` (the default) or `.error(message)`. It fills the available
width and the field is at least 56pt tall.

The input only draws the status it is given. Whether a value is valid, and when to start showing the error, is
decided by the screen using it.

| Part | Look |
|---|---|
| Field | `background` fill, 16pt horizontal padding, `CornerRadius.large` corners |
| Placeholder | `bodyLarge`, `textSecondary` |
| Entered text | `bodyLarge`, `textPrimary`; the cursor is `primary` |
| Prefix | `bodyLargeMedium`, `textSecondary`, 8pt before the text |
| Label | `bodySmallMedium`, `textPrimary`, 4pt above the field |
| Error message | `bodySmall`, `error`, 4pt below the field |

| State | Border |
|---|---|
| Default | 1pt `border` |
| Focused | 2pt `primary` |
| Error (`status: .error(message)`) | 2pt `error`, also while focused; the message shows below the field |
| Disabled (set with `.disabled(_:)`) | The whole input drops to 50% opacity and can't be focused |

- **Focus:** tapping anywhere on the field focuses it, not only the text
- **Keyboard:** `.keyboardType(_:)` and `.textContentType(_:)` applied to the input reach the field
- **VoiceOver:** the field is named by its label, or by its placeholder when there is no label; the visible label is not read twice, and the error message is read after the field

## Radio Buttons

`SingleSelectGroup` shows a list of options where one can be chosen. It takes `SingleSelectGroup.Option`s (an id and a
`String` title), the currently selected id (`nil` when nothing is chosen yet) and an `onSelect` callback.

- **Selection:** tapping an option calls `onSelect` with its id. The group shows whatever `selection` it is
  given, so the caller stores the new id and the previous option is shown unselected.
- **Layout:** full-width rows stacked 12pt apart.

`RadioListItem` is one row on its own, taking a `String` title, `isSelected` and an action, for screens that
lay options out themselves.

| Part | Selected | Unselected |
|---|---|---|
| Row fill | `selectedSubtle` | `background` |
| Row outline | 2pt `selected` | 1pt `border` |
| Indicator (24pt) | `selected` circle with a 10pt `background` dot | 2pt `border` ring |
| Title | `bodyMediumMedium`, `textPrimary` | same |

- **Row layout:** at least 64pt tall, 20pt horizontal padding, 12pt between indicator and title, `CornerRadius.large` corners
- **Tapping:** the whole row is tappable, not just the indicator
- **Disabled:** set with `.disabled(_:)`; the row drops to 50% opacity and ignores taps

## Multi Select

`MultiSelectGroup` shows a list of options where any number can be checked. It takes `MultiSelectGroup.Option`s
(an id and a `String` title), the set of checked ids and an `onToggle` callback.

- **Toggling:** tapping an option calls `onToggle` with its id. The group shows whatever `selection` it is given,
  so the caller adds the id to or removes it from the set. Each option toggles on its own.
- **Layout:** full-width rows stacked 12pt apart.

`CheckboxListItem` is one row on its own, taking a `String` title, `isChecked` and an action, for screens that lay
options out themselves.

| Part | Checked | Unchecked |
|---|---|---|
| Row fill | `selectedSubtle` | `background` |
| Row outline | 2pt `selected` | 1pt `border` |
| Checkbox (24pt, `CornerRadius.small` corners) | `selected` fill with a bold 14pt `checkmark` SF Symbol in `background` | 2pt `border` outline |
| Title | `bodyMediumMedium`, `textPrimary` | same |

- **Row layout:** at least 64pt tall, 20pt horizontal padding, 12pt between checkbox and title, `CornerRadius.large` corners
- **Tapping:** the whole row is tappable, not just the checkbox
- **Disabled:** set with `.disabled(_:)`; the row drops to 50% opacity and ignores taps

## Progress Bar

`ProgressBar` shows how far the user has got through a flow. It takes a `progress` `Double` from `0` (empty) to `1`
(full); the screen using it works the value out, for example the current step divided by the total.

| Part | Look |
|---|---|
| Track | `border` rectangle with square corners, full width, 4pt tall |
| Fill | `primary` rectangle with square corners, growing from the leading edge |

- **Out of range:** a `progress` below 0 shows empty, above 1 shows full
- **Animation:** the fill animates with `.smooth` whenever `progress` changes
