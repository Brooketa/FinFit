# CoreUI

The design system every feature draws with.

| Area | Holds |
|---|---|
| `Palette` | The design's colors, each a color set in `Assets.xcassets` with a single, light appearance — see **Colors** below |
| `TextStyle` | `title`, `headline`, `body` on the system font, scaling with Dynamic Type; applied with `.textStyle(_:)` |
| `Spacing` | A 4pt grid: `extraSmall` 4, `small` 8, `medium` 12, `large` 16, `extraLarge` 24, `extraExtraLarge` 32; applied with `.padding(_:)` |
| Alignment | `alignLeading/Trailing/HorizontalCenter`, `alignTop/Bottom/VerticalCenter`, the four corners and `alignCenter` — each expands the view and pins it |
| `PrimaryButton` | Full-width, primary-filled button with a localized title |

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
