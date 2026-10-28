# CoreUI

The design system every feature draws with.

| Area | Holds |
|---|---|
| `Palette` | `backgroundPrimary`, `backgroundSecondary`, `textPrimary`, `textSecondary`, `accent` — each a color set in `Assets.xcassets` with a light and a dark appearance |
| `TextStyle` | `title`, `headline`, `body` on the system font, scaling with Dynamic Type; applied with `.textStyle(_:)` |
| `Spacing` | A 4pt grid: `extraSmall` 4, `small` 8, `medium` 12, `large` 16, `extraLarge` 24, `extraExtraLarge` 32; applied with `.padding(_:)` |
| Alignment | `alignLeading/Trailing/HorizontalCenter`, `alignTop/Bottom/VerticalCenter`, the four corners and `alignCenter` — each expands the view and pins it |
| `PrimaryButton` | Full-width, accent-filled button with a localized title |
