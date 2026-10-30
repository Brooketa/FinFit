# Project Structure

## Overview

The app is a thin target over **local Swift packages**, each a folder at the repository root. The
packages hold everything; the app target holds the entry point, the router and the dependency wiring.

Every package is referenced by the Xcode project as a **local folder**, so it shows in the project
navigator next to the app target and can be browsed and edited like any other group — the way an
embedded framework would appear. There is no `.xcworkspace`, no `Packages/` container folder, and no
local package under *Package Dependencies* (see **Packages In The Project File**).

Modules are organized in a strict dependency hierarchy. A module may only depend on modules **lower**
in the hierarchy — never on a sibling feature module or a module above it.

```
App (main target)
 └── Feature modules        (e.g. Profile, Checkout, Settings)
      ├── CoreUI
      │    └── Core
      └── Networking
           └── Core
```

`CoreUI` and `Networking` sit side by side: a feature may use either or both, and neither imports the other.

No circular dependencies are permitted. Feature modules never import each other; the app target
connects them through their routing protocols (see `architecture.md` → Navigation).

The modules a project actually has, and what each holds, are listed in its `CLAUDE.md`.

---

## Module Tiers

### Core

The lowest-level foundation: non-UI services and extensions too small to justify their own module.

**What belongs here:**
- Foundation type extensions (`String`, `Date`, `Array`, `URL`, …) and small value types used broadly
- Lightweight services with no UI (logging, formatting, `UserDefaults` access)
- Shared protocols and generic utilities (`Debouncer`, `KeychainWrapper`)
- Constants and configuration values
- Domain types, data stacks and stores that more than one feature needs

**What does not belong here:**
- Anything that imports SwiftUI or UIKit
- Anything only one feature uses

**Dependencies:** third-party only.

### CoreUI

Every reusable UI building block — anything SwiftUI used by two or more modules.

**What belongs here:**
- Design tokens: colors, typography, spacing — under `Design/`, one subfolder per token family
- Fonts, and images and icons shared across modules — in CoreUI's asset catalog, exposed through
  `AppImages` (see **Images**)
- Reusable components: buttons, cards, sheets, headers, backgrounds, empty and loading states
- View modifiers and view extensions, including the alignment and padding helpers
- `Shape`s, `Style`s and `PreferenceKey`s
- UI-facing utilities that are not views (a display-link driver shared by animations) — in `Utilities/`
- Protocol-backed, constructor-injected UI services (haptics, orientation) — in `Services/`

```
CoreUI/Sources/CoreUI/
├── Design/
│   ├── Colors/
│   ├── Typography/
│   └── Spacing/
├── Components/
├── Modifiers/
├── Extensions/
├── Images/
│   └── AppImages.swift                 # Public ImageResource tokens
├── Services/
├── Utilities/
└── Resources/
    ├── Assets.xcassets                 # Color sets and images
    └── Fonts/
```

**What does not belong here:**
- Business logic, state management or domain data
- UI used by only one module
- Network or data models

**Dependencies:** `Core` only.

### Networking

The shared HTTP layer: the base network client every feature's own network client delegates to.

**What belongs here:**
- The base network client and its protocol — the abstraction over `URLSession`
- What a request is made of: HTTP methods, request descriptions, the errors a request can fail with
- The JSON encoders and decoders requests and responses share

**What does not belong here:**
- Feature-specific network clients, endpoints and their models — those live in the feature's data stack
  (see **Layers**)
- Anything that imports SwiftUI or UIKit

**Dependencies:** `Core` and third-party only.

### Feature Modules

Each feature module is **one user-facing product area**. It owns its screens, its routing protocol,
its String Catalog, its asset catalog and its own `Module+Factory.swift`.

**Dependencies:** `Core`, `CoreUI` and `Networking`. Never another feature module.

---

## Dependency Rules

| Module | Can depend on |
|---|---|
| `Core` | Third-party only |
| `CoreUI` | `Core` |
| `Networking` | `Core`, third-party |
| Feature module | `Core`, `CoreUI`, `Networking` |
| App target | All modules |

- **No feature-to-feature imports.** If two features need to share something, move it down: non-UI
  into `Core`, UI into `CoreUI`.
- **No upward dependencies.** Lower modules never import higher ones.

---

## Repository Layout

```
MyApp/
├── MyApp.xcodeproj
├── MyApp/                              # App target
│   ├── App/
│   │   ├── MyApp.swift                 # @main
│   │   ├── RootView.swift              # Root screen switch / navigation stack
│   │   ├── AppRouter.swift             # Navigation state; conforms to each routing protocol
│   │   ├── AppBootstrap.swift          # Launch preparation
│   │   └── DependencyInjection/
│   │       ├── Container+App.swift
│   │       └── Container+Routing.swift
│   ├── Assets.xcassets                 # App icons only
│   └── Info.plist
├── MyAppTests/                         # Unit tests for the app target, hosted by the app
├── Core/
├── CoreUI/
├── Networking/
├── <SharedModule>/
├── <FeatureModule>/
├── .claude/
└── CLAUDE.md
```

Every package has the same outer shape:

```
<Module>/
├── Package.swift
├── Docs/                               # Behavioural specs — see workflow.md → Feature Spec Files
├── Tests/
│   └── <Module>Tests/                  # The module's test target
│       ├── Resources/JSON/             # Backend responses, for client-layer tests
│       ├── Fixtures/                   # Fixtures shared by several subjects
│       └── <Subject>Tests/             # One folder per subject under test
│           ├── <Subject>Tests.swift
│           ├── Fixtures/               # <Type>+Fixtures.swift
│           ├── Mocks/
│           └── Models/                 # Types that exist only for the tests
└── Sources/
    └── <Module>/
        ├── Module+Factory.swift        # The module's own registrations, if it has any
        ├── Common/                     # Shared by the module's screens
        ├── Resources/                  # Beside Common/, not inside it
        │   ├── Assets.xcassets
        │   └── Localization/
        │       └── Localizable.xcstrings
        └── ...
```

- The package folder, the `Package.swift` product, the target and the `Sources/<Module>/` folder all
  carry the **same** module name.
- Sources always sit under `Sources/<Module>/`, never directly under `Sources/`. Everything a module
  has — `Common/`, `Resources/`, `UI/`, `Module+Factory.swift` — is inside that one folder, so it is
  all visible in the navigator under the module's name.
- `Resources/` sits **beside** `Common/`, not inside it. SwiftPM requires resources to live inside the
  target's folder, and they are declared in `Package.swift` with `resources: [.process("Resources")]`.
- `Docs/` sits at the package root, beside `Package.swift` — not under `Sources/`.

---

## Feature Module Internal Structure

```
FeatureName/Sources/FeatureName/
├── Module+Factory.swift
├── UI/
│   ├── ScreenOne/
│   │   ├── ScreenOneView.swift
│   │   ├── ScreenOnePresenter.swift
│   │   ├── Components/
│   │   │   ├── LeafComponent.swift
│   │   │   ├── ParentComponent/        # Owns a child — folder
│   │   │   │   ├── ParentComponent.swift
│   │   │   │   └── Components/
│   │   │   │       └── ChildComponent.swift
│   │   │   └── Dialogs/                # Presented over the screen
│   │   ├── Models/                     # The screen's standalone view models
│   │   ├── Utilities/                  # The screen's non-view logic, e.g. state being edited
│   │   └── UseCase/                    # Used by this screen only
│   │       ├── DomainUseCase.swift
│   │       ├── DomainUseCaseProtocol.swift
│   │       └── DomainUseCaseModel.swift
│   └── ScreenTwo/
│       └── ...
├── UseCase/                            # Shared by the module's screens
├── <Concept>/                          # A data stack, if the module owns one
│   ├── Repository/
│   ├── DataSource/
│   └── Client/
├── Stores/
├── Common/
│   ├── Components/                     # UI used by more than one screen
│   ├── Extensions/
│   ├── Navigation/
│   │   └── FeatureNameRoutingProtocol.swift
│   └── Settings/                       # The module's narrowing of a Core store
└── Resources/
    ├── Assets.xcassets                 # Images used only by this module
    └── Localization/
        └── Localizable.xcstrings
```

A module whose work is not only screens keeps the same `UI/`, `Common/` and `Resources/` shape for
its SwiftUI, and adds a top-level folder per kind of work it does — a module hosting a SpriteKit scene
might add `Scene/`, `Nodes/` and `Stores/`. Name each folder for what it holds, not for a screen.

Compact and Regular layouts of one screen are siblings of the container view in the screen folder,
with the `Components/` they share next to them. A layout variant only gets a folder of its own when
it owns a component the other variant does not use.

### Layers

A screen gets only the layers it needs (see `architecture.md` → Only the layers that have a job).
Layers live at the narrowest scope that owns every caller:

- A UseCase used by one screen sits in that screen's folder; one shared by the module's screens sits in
  the module's `UseCase/`.
- A data stack sits in a folder named for the domain concept it serves, with one subfolder per layer —
  `<Concept>/{Repository,DataSource,Client}/`. If more than one feature needs it, it moves to `Core`.
- A `UserDefaults` store sits at UseCase level: `…StoreProtocol` plus `UserDefaults…Store`, in
  `Stores/`, at the narrowest scope that owns every caller. Persistence of real data (database, files,
  Keychain) is a DataSource inside a data stack.

| Layer | Responsible for | Consumed by |
|---|---|---|
| Presenter | The screen's state; calls UseCases and maps their models into the view's `Model` | The View |
| UseCase | Business logic; orchestrates Repositories and Services | The Presenter |
| Repository | Choosing the source of truth; orchestrates DataSources | The UseCase |
| DataSource | Reading or writing one origin of data — network, database, files, Keychain | The Repository |
| Client | Request construction against a base client or SDK | The DataSource |
| Store | Persisting a few preferences or flags in `UserDefaults` | The Presenter |
| Service | Wrapping a system or SDK capability | The UseCase or Presenter |

### File Naming

Files are named after **the domain concept they handle**, not the screen they serve:
`<DomainConcept><Layer>.swift`, each beside its `…Protocol.swift` and its `…Model.swift`.

| Folder | File | Holds |
|---|---|---|
| `UseCase/` | `DomainUseCase.swift` | The concrete use case |
| `UseCase/` | `DomainUseCaseProtocol.swift` | The protocol the Presenter sees |
| `UseCase/` | `DomainUseCaseModel.swift` | The use case's models |
| `Repository/` | `DomainRepository.swift`, `…Protocol.swift`, `…Model.swift` | The same three, one layer down |
| `DataSource/` | `DomainDataSource.swift`, `…Protocol.swift`, `…Model.swift` | The same three, one layer down |
| `Client/` | `DomainClient.swift`, `…Protocol.swift`, `…Model.swift` | The same three, one layer down |
| `Stores/` | `DomainStoreProtocol.swift`, `UserDefaultsDomainStore.swift` | A store and its protocol |

The screen folder names **the screen's purpose**; the layer files name **the concept they operate
on**. The two can differ — two screens reading the same concept share one UseCase, at the module level.

---

## Worked Example — A Recipes Feature

An app with a `Recipes` feature that lists recipes, shows one in detail, loads the recipe catalogue
from a file and remembers favourites.

```
Recipes/Sources/Recipes/
├── Module+Factory.swift
├── UI/
│   ├── RecipeList/
│   │   ├── RecipeListView.swift
│   │   ├── RecipeListPresenter.swift
│   │   └── Components/
│   │       ├── FilterBar.swift
│   │       └── RecipeRow/
│   │           ├── RecipeRow.swift
│   │           └── Components/
│   │               └── Thumbnail.swift
│   └── RecipeDetail/
│       ├── RecipeDetailView.swift
│       ├── RecipeDetailPresenter.swift
│       └── Components/
│           ├── IngredientList.swift
│           └── Dialogs/
│               ├── ShareDialog.swift
│               ├── ServingsDialog.swift
│               └── Components/
│                   └── DialogHeader.swift
├── UseCase/                            # Both screens read recipes
│   ├── RecipesUseCase.swift
│   ├── RecipesUseCaseProtocol.swift
│   └── RecipeUseCaseModel.swift
├── Recipes/                            # The catalogue's data stack
│   ├── Repository/
│   │   ├── RecipeRepository.swift
│   │   ├── RecipeRepositoryProtocol.swift
│   │   └── RecipeRepositoryModel.swift
│   ├── DataSource/
│   │   ├── RecipeDataSource.swift
│   │   ├── RecipeDataSourceProtocol.swift
│   │   └── RecipeDataSourceModel.swift
│   └── Client/
│       ├── RecipeFileClient.swift
│       ├── RecipeFileClientProtocol.swift
│       └── RecipeClientModel.swift
├── Stores/
│   ├── FavouritesStoreProtocol.swift
│   └── UserDefaultsFavouritesStore.swift
├── Common/
│   ├── Components/
│   │   └── RatingBadge.swift           # Shown on the row and on the detail
│   └── Navigation/
│       └── RecipesRoutingProtocol.swift
└── Resources/
    ├── Assets.xcassets                 # recipe_placeholder → Image(.recipePlaceholder)
    └── Localization/
        └── Localizable.xcstrings
```

Read off the paths:

- `Thumbnail` is drawn only by `RecipeRow`, so it sits inside `RecipeRow/`. Deleting `RecipeList/`
  deletes it too.
- `RatingBadge` has callers on both screens, so it sits in `Common/Components/`.
- `RecipesUseCase` serves both screens, so it sits in the module's `UseCase/`, named for the concept
  rather than either screen.
- The catalogue's stack lives in a folder named for the concept. `RecipesUseCase` reaches it through
  `RecipeRepository`; the presenters hold `FavouritesStore` directly, beside the UseCase.
- If a second feature needed the catalogue or the favourites, the stack and the store would move to `Core`.

---

## Component Scoping

A folder is a **deletable unit**. Deleting `ScreenOne/` must also delete `ParentComponent` and
everything `ParentComponent` uses, because nothing else uses them. The folder tree is the ownership
graph — you read a component's scope off its path.

**1. A component lives in the `Components/` folder of the view that uses it.**

**2. A component used by two or more views moves up to their nearest common ancestor.** It goes in the
`Components/` of the closest view that owns them both — never duplicated, never left beside only one
of its callers.

**3. A view that owns sub-components gets a folder named after it. A leaf view stays a bare file.**

```
Components/
├── SummarySection.swift         # Leaf — bare file
└── ActivitySection/             # Owns a child — folder
    ├── ActivitySection.swift
    └── Components/
        └── ActivityRow.swift
```

**4. A plural "group" folder is allowed when its members play the same structural role.** The group
folder owns a `Components/` for whatever its members share, and is itself a deletable scope.
Grouping by role means how a view is presented and composed, not what it happens to be called. A
`Sections/` around whatever is named `…Section` does not earn a folder.

`Dialogs/` is the standing case. A dialog is not part of the screen's layout: headers, lists and
footers compose *into* the view's body, while a dialog is presented modally *over* it. Every screen
with dialogs gets a `Dialogs/` in its `Components/`, whether or not the dialogs share anything.

Components carry no screen prefix: `Header`, not `ProfileHeader`. The folder is the scope.

Non-view helpers scope the same way: a helper used by one view sits beside it inside its folder; a
helper shared by a folder's members goes in that folder's `Components/`.

---

## Promotion Rules

Promotion is the Component Scoping rules applied upward: a component always sits at the nearest scope
that owns every one of its callers. When a second caller appears, move the component up — do not
duplicate it, and do not leave it beside only one of them.

| Originally in | Needed by | Move to |
|---|---|---|
| A view's `Components/` | A sibling view in the same screen | The `Components/` of their nearest common ancestor |
| A layout variant's `Components/` | The other layout variant | The screen's `Components/` |
| A screen's `Components/` | Another screen in the same module | `<Module>/Common/Components/` |
| A screen's layer (`UseCase/`, …) | Another screen in the same module | The module-level folder for that layer |
| `Common/Components/` | Another module | `CoreUI/Components/` |
| `Common/Extensions/` | Another module | `Core/Extensions/` (non-UI) or `CoreUI/Extensions/` (UI) |
| An image in the module's asset catalog | Another module | CoreUI's asset catalog, exposed through `AppImages` |
| A module's data stack or store | Another module | `Core` |

---

## Packages In The Project File

**Every first-party module is tracked in the app's `project.pbxproj` as a local folder reference.**
That is what puts it in the project navigator beside the app target. Only third-party libraries are
tracked any other way — those come in as remote package references, pinned by version.

**Never add a local package through _Package Dependencies_.** That writes an
`XCLocalSwiftPackageReference` into the project's `packageReferences` and parks the package under the
Package Dependencies node. It is the more obvious route in Xcode's UI and it is the wrong one.
`packageReferences` is reserved for remote dependencies; no local package ever appears there.

A first-party module is never pointed at by URL, never vendored as a binary, and never left to resolve
implicitly as a transitive SPM dependency of another package.

A module is tracked correctly when it appears in all of these — once per app target where a section is
per target:

| Section | Entry |
|---|---|
| `PBXFileReference` | `lastKnownFileType = wrapper; path = <Module>; sourceTree = "<group>";` — the folder itself |
| Main group `children` | listed beside the other packages |
| `XCSwiftPackageProductDependency` | `productName = <Module>;` only — no `package` key |
| `packageProductDependencies` | the product dependency, on each app target |
| `PBXBuildFile` | `<Module> in Frameworks`, with `productRef` pointing at the product dependency |
| `PBXFrameworksBuildPhase` | the same build file, in each app target's Frameworks phase |

Add these in the same change that creates the package. Afterwards, confirm `packageReferences` still
contains no local package.

A module whose product is **dynamic** also needs an **Embed Frameworks** (`PBXCopyFilesBuildPhase`) entry,
or the app links a framework it does not ship and dies at launch. A Debug build can hide this.

**A green build is not evidence the package is tracked.** Xcode resolves a package reached only
through another package's `Package.swift` and builds it happily, so the app compiles while the
package is invisible in the project. Check the project file, not the build result.

Cross-package dependencies are declared by relative path:

```swift
dependencies: [
    .package(name: "Core", path: "../Core"),
    .package(name: "CoreUI", path: "../CoreUI")
],
targets: [
    .target(
        name: "Recipes",
        dependencies: ["Core", "CoreUI"],
        resources: [.process("Resources")])
]
```

---

## Adding a New Module Checklist

1. Create the package folder at the repository root, with `Package.swift`, `Sources/<Module>/` and
   `Docs/`, all named after the module
2. Declare the same platform and Swift language mode as the other packages
3. Depend only on modules allowed by **Dependency Rules**
4. Track the package in the project file and link its product to every app target — see
   **Packages In The Project File**
5. If it has screens, give it a routing protocol in `Common/Navigation/`, conform `AppRouter` to it, and
   register the router for it in `Container+Routing.swift`
6. If it ships a `Localizable.xcstrings`, declare `defaultLocalization: "en"` in `Package.swift`
7. Add it to the module map in `CLAUDE.md`

## Adding a New Screen Checklist

1. Create `<Module>/Sources/<Module>/UI/<ScreenName>/`
2. Add `<ScreenName>View.swift` and `<ScreenName>Presenter.swift`, and register the presenter in
   `Module+Factory.swift`
3. Add `Components/` following **Component Scoping**, and only the layers the screen needs
4. If a layer for the same domain concept already exists in the module, reuse it — do not duplicate
5. Add `<Module>/Docs/<ScreenName>Screen.md`

---

## Images

Images work the same way as strings: they live in a catalog, and code reaches them through the
symbols Xcode generates from it — `ImageResource` for images, as `LocalizedStringResource` is for strings.

- Every image is an image set in an **asset catalog** — the module's own
  `Resources/Assets.xcassets` if only that module draws it, CoreUI's if more than one does.
- Asset names are `lowercase_with_underscores`, and are camelCased into symbols
  (`recipe_placeholder` → `.recipePlaceholder`).
- Views reference the generated symbol directly:

```swift
// ✅
Image(.recipePlaceholder)

// ❌
Image("recipe_placeholder")
Image(uiImage: UIImage(named: "recipe_placeholder")!)
```

- Never use an image name as a string literal, and never hand-write an `ImageResource` extension — the
  generated symbols will collide with it.
- Generated symbols are `internal` to the module that owns the catalog. CoreUI exposes its shared
  images to other modules through a `public` `AppImages` enum of `ImageResource` values, so a feature
  writes `Image(AppImages.logo)`.
- Symbol generation must be enabled for the catalog: **Generate Swift Asset Symbols** for the app target,
  and the catalog declared in `Package.swift` with `resources: [.process("Resources")]` for a package.

Colors follow the same pattern as color sets — see `code-style.md` → Never build a color from raw components.

## Localized Strings

Each module owns its own `Localizable.xcstrings` and declares it as a resource. Xcode generates the
`LocalizedStringResource` symbols from the catalog, so views reference keys directly:

```swift
Text(.itemListTitle)
```

Never hand-write `LocalizedStringResource` extensions — the generated symbols will collide with them.

Symbol generation only runs when the package declares `defaultLocalization`. Without it the catalog still
compiles and ships correctly, but no symbols are emitted and every call site fails with
`reference to member '…' cannot be resolved without a contextual type`.

Catalog keys are snake_case and are camelCased into symbols (`item_list_title` → `itemListTitle`).
Name every placeholder to get a labelled argument, and use `lld` rather than `d` so the argument is `Int`:

```
%1$(done)lld/%2$(total)lld items   ->  itemProgressLabel(done: Int, total: Int)
%1$lld/%2$lld items                ->  itemProgressLabel(_: Int, _: Int)
%1$(count)d items                  ->  itemCountLabel(count: Int32)
```
