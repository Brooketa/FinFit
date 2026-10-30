# Core

Non-UI foundation shared by every module.

| Area | Holds |
|---|---|
| `Bundle.marketingVersion` | The bundle's `CFBundleShortVersionString`, or an empty string when it has none |
| `UserDefaultsService` | Reads, writes and removes values in `UserDefaults` — see **UserDefaults service** below |

## UserDefaults service

`UserDefaultsServiceProtocol` saves small values that must outlive the app, such as a preference or the id of
something in progress. Modules build their own stores on it rather than touching `UserDefaults` directly.

| Call | Does |
|---|---|
| `read(forKey:)` | Returns the value saved under the key, decoded from JSON, or `nil` when nothing is saved there |
| `write(_:forKey:)` | Saves any `Encodable` value under the key as JSON, replacing what was there |
| `remove(forKey:)` | Removes whatever is saved under the key |

- **Access:** resolved from the container as `userDefaultsService`, backed by `UserDefaults.standard`
- **Errors:** `read` throws when the saved data can't be decoded as the requested type; `write` throws when the value
  can't be encoded
