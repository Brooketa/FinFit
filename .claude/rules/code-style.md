# Swift Code Style Rules for Claude

> When generating, reviewing, or modifying Swift code, Claude must follow all rules below without exception.

---

## Naming

- Use `UpperCamelCase` for types and protocols; `lowerCamelCase` for variables, constants, and functions.
- Prioritize clarity over brevity — use the minimum number of words that **clearly** describe the entity.
- Name variables and parameters by their **role**, not their type.
- Name functions and methods according to their **side-effects**.
- Avoid obscure terms, abbreviations, and redundant words.
- Place parameters with default values toward the end of the parameter list.
- Always label tuple members and name closure parameters.
- Protocol naming:
  - Default: suffix with `Protocol` (e.g., `NetworkingProtocol`)
  - Delegate protocols: suffix with `Delegate` (e.g., `ImageDownloaderDelegate`)
  - Descriptive protocols: suffix with `able` (e.g., `Equatable`, `Runnable`)
- Do **not** add class prefixes (e.g., `CoreUIRoundedButton`). Use module-qualified syntax instead: `CoreUI.RoundedButton()`.
- Generic type parameters must be descriptive `UpperCamelCase`. Use single-letter names (`T`, `U`) only when the type has no semantic meaning.

### Event Functions

Presenter functions the View calls are **event handlers** and must be prefixed with `on`. Name them
after the event that occurred, not the work the presenter does in response:

```swift
// ✅
func onAddItemTapped()
func onConfirmDelete()
func onSelect(item: ItemModel)

// ❌
func addItemTapped()
func confirmDelete()
func select(item: ItemModel)
func initialSetup()
```

The prefix marks the direction of the call. Everything below the Presenter — UseCase, Repository,
DataSource, Client, Store, and the services they wrap — receives **commands**, not events, so those keep
plain verb names with no prefix:

```swift
// ✅
func onEnterBackground() {
    sessionService.disconnect()
}
```

Private helpers inside a Presenter are not events. They keep verb names (`loadSettings()`,
`rebuildList()`) regardless of which event function calls them.

**Exception: the work a screen starts when it appears.** A view's `.task` or `.onAppear` calls a presenter
function named for the work it does, not `onAppear()` — "appeared" says nothing about what happens next.
The name must say exactly what is done; a vague one is still wrong:

```swift
// ✅
.task {
    await presenter.startOrResumeSession()
}

// ❌
.task {
    await presenter.onAppear()
}

func initialSetup()
```

### Injected Dependencies

An injected dependency is named for **what it provides plus its kind** — `progressStore`,
`settingsUseCase`, `audioService`, `itemRepository`. The same spelling is used for the parameter, the
stored property and every call site, so a holder's signature reads the same wherever it appears.

The kind is part of the **role**, not the type. `Store`, `UseCase`, `Service`, `Repository` and `Client`
say where a dependency sits in the architecture, which is exactly what the reader needs when one holder
takes several at once — naming them all for the bare noun would hide that they are reached through
different layers.

A **value** keeps the bare noun. What decides it is what the type does, not what it is called:

```swift
// ✅
final class OptionsPresenter {

    private let settingsUseCase: SettingsUseCaseProtocol
    private let audioService: AudioServiceProtocol

    private var settings: SettingsUseCaseModel

}
```

`settingsUseCase` is a thing the presenter calls; `settings` is the value it fetched from it.

Parameters are ordered **screen inputs, then dependencies, then the router**, so a new presenter's
signature follows from the convention rather than from its neighbour:

```swift
// ✅
init(itemID: Item.ID, itemUseCase: any ItemUseCaseProtocol, router: any ItemRoutingProtocol)

// ❌
init(router: any ItemRoutingProtocol, itemID: Item.ID, itemUseCase: any ItemUseCaseProtocol)
```

### Delegates

The first parameter of a custom delegate method must be unnamed and contain the delegate source:

```swift
// ✅
func imageDownloader(_ imageDownloader: ImageDownloader, didFinishDownloading: Bool)

// ❌
func didFinishDownloading(imageDownloader: ImageDownloader)
```

---

## Construction

### Build a type with its own `init`

When one type is built from another, the conversion is a custom `init` on the type being built,
declared in an extension of it. Construction is scoped to the model it constructs, so the way to make
a value is always found on that value's type — not in a helper somewhere in whichever class happened
to need it first.

```swift
// ✅
extension ItemCard.Model {

    init(from model: ItemUseCaseModel) {
        self.init(
            id: model.id,
            title: model.name,
            subtitle: model.category,
            isSelected: false)
    }

}

items = try await itemUseCase.fetchItems()
    .map { ItemCard.Model(from: $0) }

// ❌
private func makeItemCardModel(from model: ItemUseCaseModel) -> ItemCard.Model { ... }

items = try await itemUseCase.fetchItems()
    .map { makeItemCardModel(from: $0) }
```

This is how every layer maps at its boundary — `ItemUseCaseModel(from:)`, `ItemRepositoryModel(from:)`,
`ItemCard.Model(from:)`. When the source is not enough on its own, the extra values are further `init`
parameters (`init(from model: ItemUseCaseModel, isSelected: Bool)`).

Declare the conversion `init` in an extension, not in the type's body, so the struct keeps Swift's
memberwise initializer.

### `make` functions are rare and take no arguments

A `make` function returns something it builds **from its holder's own state**, and takes **no
arguments**. Anything that needs input is an `init` on the type being made.

```swift
// ✅
func makeHeaderModel() -> Header.Model

// ❌
func makeHeaderModel(title: String, count: Int) -> Header.Model
func makeRowModel(from item: ItemUseCaseModel) -> Row.Model
```

Keep them few. A class collecting `make…` functions is doing the work of the types it builds; move each
one to an `init` on its result type.

## Code Organization

### Extensions

- Write a **separate extension** for each protocol conformance.
- If the extension does not require changing property visibility → put it in a **new file**.
- If it requires relaxing visibility → put it in the **same file**, with a `// MARK:` comment.

### Protocol Conformance

- Implement protocol methods in extensions, not inline in the type declaration.
- Exception: protocols that provide default implementations or without which the object makes no sense (e.g., `Equatable`, `Codable`) may be listed inline.

### Unused Code

Remove all unused or dead code without exception:
- Xcode template stubs (e.g., `didReceiveMemoryWarning`)
- Functions with no callers
- Commented-out code
- Functions that only call `super`
- Incomplete `// TODO:` stubs

#### Exception: complete helper sets in `Core` and `CoreUI`

A `Core` or `CoreUI` helper set that covers a **closed set of cases** ships whole, including variants
that have no caller yet. The alignment helpers are the standing example: every edge, corner and axis
exists because a developer must be able to guess the name without checking which ones were needed so far.

This is the only exemption. It does not license speculative API in general:

- The set must be **closed and obvious** — an enumeration of positions, states or directions the
  platform already defines, not a guess at what a future screen might want.
- It must live in `Core` or `CoreUI` as shared vocabulary, never in a feature module.
- A partially-populated set is worse than none, because the gaps get filled one-off per screen,
  which is exactly what the set exists to prevent.

Anything outside that shape is still dead code and still gets deleted.

### Imports

- Import only modules that are actively used. Remove unused imports.
- Import order: **Apple frameworks → Third-party frameworks → Project modules**, alphabetically within each group.

```swift
// ✅
import SwiftUI
import UIKit
import FactoryKit
import Core
import CoreUI
```

### Namespacing

Use `enum` (not `struct`) for namespaces, since enums cannot be instantiated:

```swift
// ✅
enum Constants {
    static let height: CGFloat = 10
}

// ❌
struct Constants {
    static let height: CGFloat = 10
}
```

#### Where `Constants` lives

A type's `Constants` enum sits in a **private extension of that type**, placed below the type rather
than above it:

```swift
struct ItemCard: View {

    var body: some View { ... }

}

private extension ItemCard {

    enum Constants {

        static let cornerRadius: CGFloat = 26

    }

}
```

Two shapes cannot express that, and **file scope is correct in both**:

- **There is no type to nest into.** A free-standing extension on a protocol — `extension View { func ... }` —
  has no type of its own, and Swift does not permit a nested type inside a protocol extension.
- **The type is generic.** Anything nested inside a generic type is itself generic, and Swift rejects a
  stored `static let` there: *static stored properties not supported in generic types*.

In both cases declare `private enum Constants` at file scope, below the type. Do not reach for a
computed `static var` to force the nesting — one file spelling its constants differently from every
other is worse than an exception that is written down.

---

## Spacing

- Indent with **4 spaces**, never tabs.
- Empty lines must contain only a newline character — no trailing spaces.
- Maximum line length: **120 characters**. Generated or hand-maintained data tables (one literal or
  record per row) are exempt.
- Add a single blank line after the opening brace of a class/struct and before the closing brace.
- Add a blank line after every `guard` statement block.
- Colons: **no space before**, **one space after**.
  - Exceptions: ternary `?:`, empty dictionary `[:]`, selectors `addTarget(_:action:)`

---

## Comments

**Do not write comments.** Never add a line comment (`//`), a documentation comment (`///`), or a
block comment (`/* ... */`) unless it has been explicitly requested. This applies to new code and to
code being modified — do not "helpfully" annotate a change, a workaround, or a non-obvious line.

Code must be self-documenting instead. If something seems to need explaining, rename it, extract it
into a named property or function, or move a magic number into a named constant until the code
reads on its own.

There are two exceptions.

### Documentation comments in `Core` and `CoreUI`

The `public` API of `Core` and `CoreUI` is documented with `///`. These are the shared packages every
other module calls into, and a caller reads them through Xcode's Quick Help at the call site, not in
the source. A comment there says **what the member gives the caller** — the value a token resolves
to, what a helper does to the view it is applied to, what a service call has done by the time it
returns — so `.padding(.extraLarge)` or `.alignLeading()` can be understood without opening the file.

```swift
// ✅
/// 24pt padding or spacing.
public static let extraLarge = grid(6)

/// Expands the view to fill the available width and pins it to the leading edge.
func alignLeading() -> some View
```

It does not license anything else:

- Only `public` declarations in `Core` and `CoreUI`. Internal and private code, and every other
  module, stays uncommented.
- One or two lines on what the caller gets, not how it is implemented or why it was built that way.
- A comment that has stopped being true is a bug: update it in the same change that alters the member.

### `// MARK:`

`// MARK:` section markers structure a file and are used throughout the codebase.

Write them **without a trailing dash** — `// MARK: Mappers`, never `// MARK: - Mappers`. Leave one
blank line after the marker, before the declaration it introduces.

Never use C-style block comments `/* ... */` under any circumstances.

Delete comments you come across that are stale or that restate the code.

---

## Classes and Structs

### `self`

Only use explicit `self` in:
- Initializers (when disambiguating)
- Escaping closures

Do **not** use `self` for regular property or method access outside of these cases.

---

## Functions

### Declarations

- Functions fitting within 120 characters → single line.
- Functions exceeding 120 characters → break parameters into separate lines, with the closing `)` and return type on their own line.
- Opening brace `{` is always on the **same line** as the return type.
- Use `()` for void input, `Void` for void output in function **types**. Do not use `-> Void` in function declarations.

```swift
// ✅
func myFunction() { ... }
let onCompleted: () -> Void

// ❌
func myFunction() -> Void { ... }
let onCompleted: () -> ()
```

### Calls

- Short calls → single line.
- Long calls → break parameters, closing `)` stays on the **last parameter line** (not a new line).

```swift
// ✅
let result = someFunction(
    param1: "value1",
    param2: "value2",
    param3: "value3")

// ❌
let result = someFunction(
    param1: "value1",
    param2: "value2",
    param3: "value3"
)
```

---

## Closure Expressions

- Use trailing closure syntax only when there is a **single** closure at the end of the argument list.
- Multiple trailing closure syntax (Swift 5.3+) is optional but acceptable.
- Give closure parameters meaningful names; use anonymous `$0` only when the context is unambiguous.
- Omit `return` in single-expression closures (Swift 5.1+).
- Each chained method using a trailing closure must be on a **new line**.

```swift
// ✅
let value = numbers
    .map { $0 * 2 }
    .filter { $0 > 50 }

// ❌
let value = numbers.map { $0 * 2 }.filter { $0 > 50 }
```

---

## Types

### Optionals

- Use optionals only to represent genuinely absent values — not as error signals.
- Do **not** encode optionality in the name (e.g., no `optionalAddress`, `maybeUser`).
- Use optional chaining `?.` for single-use access. Unwrap with `if let` / `guard let` for repeated access.
- When unwrapping, reuse the same name (shadow the optional). Never use `strongSelf`, `unwrappedValue`, etc.

#### Do not return an optional the caller must unwrap

Never call a function and then check whether what it returned exists. A function that hands back an
optional pushes a decision it already made onto every one of its callers, and the `if let` that
follows sits between the reader and the thing being built.

```swift
// ✅
OptionsSection(model: presenter.optionsSection)

// ❌
if let model = presenter.optionsSection {
    OptionsSection(model: model)
}
```

Return a non-optional instead — a loaded default, an empty collection, a neutral value. This matters
most in a `View`: a builder that renders nothing while a value is missing makes its container collapse
to nothing too, so an absent model becomes a broken layout rather than a blank row.

Optionals are still right for values genuinely absent in the domain. Unwrap those once, with `guard`,
where they enter — not repeatedly at each call site.

### Type Inference

Let the compiler infer types wherever possible:

```swift
// ✅
let name = "MyName"
var names: [String] = []

// ❌
let name: String = "MyName"
var names = [String]()
```

Explicit type annotation is acceptable for:
- `CGFloat`, `DayOfWeek`, and other cases where the inferred type would differ from intent.

### Syntactic Sugar

Always use shorthand syntax:

```swift
// ✅
var names: [String]
var map: [Int: String]
var value: Int?

// ❌
var names: Array<String>
var map: Dictionary<Int, String>
var value: Optional<Int>
```

---

## Functions vs Methods

Prefer **methods** over free functions. Use free functions only when behavior is not associated with any type (e.g., `zip`, `max`).

---

## Memory Management

- Never create retain cycles. Use `weak` or `unowned` references, or value types.
- Always capture `[weak self]` in `@escaping` closures. Prefer `weak` over `unowned`.
- After capturing `[weak self]`, immediately unwrap with:

```swift
guard let self = self else { return }
```

Do not scatter optional chaining (`self?.`) throughout the closure body.

---

## Access Control

- Default to `private`. Prefer `private` over `fileprivate`.
- Use `public` or `open` only when explicitly required for cross-module visibility.
- Declare the least restrictive access level that still satisfies requirements.

---

## Type Layout

A type is laid out in this order:

1. Nested types and `typealias`es
2. Stored properties
3. `init`
4. Computed properties
5. Methods

**Computed properties are members, not state** — they belong with the methods below `init`, never
among the stored properties above it.

Stored properties are ordered by priority:
1. `static` before non-static
2. `open` → `public` → `internal` → `fileprivate` → `private`
3. `let` before `var`
4. Inline-initialized before lazily/externally initialized

Computed properties follow the same visibility ordering as methods: `open` → `public` → `internal` →
`fileprivate` → `private`, `static` before non-static.

Separate static/non-static groups and different visibility groups with a blank line.

```swift
// ✅
@Observable
final class ItemPresenter {

    var items: [ItemCard.Model] = []
    var isShowingDetail = false

    private let itemUseCase: ItemUseCaseProtocol

    private var selectedItem: Item?

    init(itemUseCase: ItemUseCaseProtocol) {
        self.itemUseCase = itemUseCase
    }

    var headerModel: ItemHeader.Model {
        ItemHeader.Model(title: title, count: items.count)
    }

    private var title: String {
        selectedItem?.name ?? ""
    }

    func loadItems() async { ... }

}
```

The same order applies inside an extension. An extension has no `init`, so its computed properties
simply precede its methods.

---

## Control Flow

### Prefer `guard` over `if`

Use `guard` to exit early and avoid deeply nested code.

### If-Else

- Braces open on the same line as the statement; close on a new line.
- Multiple conditions: each condition on its own line, opening brace on a new line.

```swift
// ✅
if
    condition1,
    condition2
{
    // ...
}

// ❌
if condition1, condition2 {
```

### Ternary Operator

- Use ternary for **value assignment** when it fits cleanly.
- Do **not** use ternary to call void-returning functions.
- Do **not** nest ternary operators — extract into a separate variable instead.
- Multiline ternary: indent 2nd and 3rd lines by 4 spaces; `?` and `:` at end of line.

```swift
// ✅
variable = condition ?
    valueWithVeryLongName1 :
    valueWithVeryLongName2
```

### Guard Statement

- Single condition with `return` → one line if it fits within 120 characters.
- Multiple conditions → each condition on its own line, `else` on its own line.
- Multiple single-condition guards that return → group them without blank lines between.
- Always leave a blank line **after** the last guard block before the next statement.

---

## Semicolons

Never use semicolons. Never write multiple statements on the same line.

---

## Parentheses

- Do not wrap single `if` conditions in parentheses.
- For complex multi-part conditions, group logically with parentheses and extract sub-conditions into named `Bool` variables.

```swift
// ✅
let isDeveloper = role == .developer
if name == "Name" && isDeveloper { }

// ❌
if (name == "Name") { }
```

---

## Multi-line String Literals

Open `"""` on the assignment line (no text on that line). Indent the content one level. Close `"""` at the correct indentation level.

```swift
// ✅
let message = """
    First line \
    Second line.
    """

// ❌
let message = """First line \
    Second line.
    """
```

---

## SwiftUI

### Never build a color from raw components

Do not write `Color(white:)`, `Color(red:green:blue:)`, `Color(hue:saturation:brightness:)`,
`UIColor(...)`, or any other literal-component initializer at a call site. A color is either a
**named token** from `CoreUI`'s `Palette` (`Palette.textSecondary`, `Palette.backgroundSecondary`, …)
or, if it genuinely does not exist yet, a **new color set in the asset catalog** — never an inline literal.

Every color is defined as a **color set in `CoreUI`'s asset catalog** and exposed through a `public`
token on `Palette` (`public static let textSecondary = Color(.textSecondary)`). The asset catalog keeps
every value in one place, so a color can change, or gain another appearance, without touching a single
view. Tokens live on `Palette` rather than on `Color` because Xcode
already generates an internal `Color` symbol for every color set, and a `public` one of the same name
would collide with it.

Reach for an existing token first. The palette is deliberately small: a design that wants "a mid grey"
almost always wants `Palette.textSecondary`, not a fresh `Color(white: 0.55)` that happens to look close.
Minting a one-off color per screen to chase a mock is how a design system rots.

```swift
// ✅
.fill(Palette.textSecondary)
.fill(Palette.backgroundSecondary.opacity(0.4))

// ❌
.fill(Color(white: 0.55))
.fill(Color(red: 0.1, green: 0.6, blue: 0.85))
```

Adjusting an existing token with `.opacity(_:)` is fine — that is a variation of a token, not a new color.
Adding a new token to `CoreUI` follows **Extending Core / CoreUI** in `workflow.md`: propose it and
wait for approval.

The one place raw components are written is **the color set itself**, in the asset catalog. Code only
ever refers to a color by name.

### Never use `Spacer`

Do not use `Spacer` — not `Spacer()`, not `Spacer(minLength:)`. Expand the element that should take the
room and give it an alignment, using the `CoreUI` alignment helpers (`alignLeading()`, `alignTrailing()`,
`alignHorizontalCenter()`, `alignCenter()`, …). They are `frame(maxWidth:alignment:)` under the hood, so the flexible
space belongs to a view that is actually in the layout rather than to an invisible sibling.

A `Spacer` states the layout as a side effect of an invisible sibling: the reader has to work out
which neighbour it is pushing and in which direction. Expanding the element that actually claims the
space says the same thing directly, survives reordering, and leaves the stack holding only things
that are really on screen.

```swift
// ✅
HStack(spacing: 16) {
    Text(title)
        .alignLeading()

    Button(action: action) { ... }
}

// ❌
HStack(spacing: 16) {
    Text(title)

    Spacer(minLength: 0)

    Button(action: action) { ... }
}
```

A `Spacer(minLength:)` that guarantees a minimum gap becomes padding on the flexible view, added to the
stack's own `spacing`.
