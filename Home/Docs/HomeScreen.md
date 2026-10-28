# Home Screen

The app's first screen. A placeholder feature that shows every rule in `.claude/rules/` working
end to end; replace it with the project's first real feature.

## Layout

| Element | What it shows |
|---|---|
| Title | "Home" |
| Counter card | The current count, with **Reset** and **+1** buttons |
| About button | Full-width primary button |

## Behaviour

- **+1** adds one to the count. **Reset** sets it to zero.
- The count is saved to `UserDefaults` on every change and restored on the next launch.
- **About** pushes the About screen.
