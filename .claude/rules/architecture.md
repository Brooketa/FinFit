# Architecture

This project follows Clean Architecture. A screen is a View and a Presenter, and below the Presenter
it gets **only the layers its data actually needs**. Each layer communicates only with the layer
directly below it, and every dependency below the Presenter is hidden behind a protocol.

**Single source of truth** is a core principle at every layer. Data enters the system at the lowest
layer a feature has and flows strictly upward. No layer reaches sideways or skips down to fetch data
from an alternative source. The Repository decides which DataSource is the source of truth; the
UseCase trusts what is below it entirely; the Presenter trusts the UseCase entirely.

---

## Layer Overview

The full chain:

```
View -> Presenter -> UseCase -> Repository -> DataSource -> Client -> BaseClient
```

Each layer has its own models. Never pass a model from one layer directly into another — always
map/convert at the boundary.

### Only the layers that have a job

A layer is added when it has work to do, never as a pass-through. These are all valid screens:

| Shape | When |
|---|---|
| `View → Presenter` | The screen has no data and no logic beyond its own UI state |
| `View → Presenter → Store` | The screen reads or writes a few preferences or flags in `UserDefaults` |
| `View → Presenter → UseCase` | The screen needs business logic over in-memory or computed data, or over a Service |
| `View → Presenter → UseCase → Repository → DataSource → Client` | Data lives in a real origin — network, database, files, Keychain, Bluetooth |

A Presenter may hold a UseCase and a Store side by side; they sit at the same level.

Two further building blocks sit beside the chain:

- **Store** — a `UserDefaults`-backed store of a few preferences or flags, behind `…StoreProtocol`
  (`UserDefaultsSettingsStore`). It sits at the **same level as a UseCase**: the Presenter holds it and
  calls it directly. A UseCase never orchestrates a Store. Anything heavier — a database, files,
  Keychain, a cache — is persistence of real data, so it is a **DataSource** below a Repository, never
  a Store.
- **Service** — wraps a system or SDK capability with no screen meaning: audio, haptics, analytics,
  Game Center. Behind `…ServiceProtocol`, injected like any other dependency.

"Never skip layers" means never skip a layer **that exists**. If a concept has a UseCase, the
Presenter goes through it; it does not reach past it to the Repository below.

---

## Dependency Injection

All dependencies are injected through the constructor (initializer injection). No layer creates its
own dependencies internally:

- View resolves its Presenter from the Factory container (see **Dependency Container** below)
- Presenter receives UseCase(s), Stores, Services and its router via constructor
- UseCase receives Repository or Service via constructor
- Repository receives DataSource(s) via constructor
- DataSource receives Client via constructor
- Client (e.g., ItemNetworkClient) receives BaseClient (e.g., BaseNetworkClient) via constructor

Every dependency **below the Presenter** is expressed as a protocol, so each layer can be replaced
without touching its neighbour.

The Presenter is **not** behind a protocol. A View resolves its Presenter as the **concrete type**. A
Presenter exists for exactly one View and is never swapped, and as an `@Observable` it must be held
concretely for observation to drive the view. A `…PresenterProtocol` adds a file and a conformance
and gives nothing back. Do not write one.

Example:

    @Observable
    final class ItemPresenter {

        private let itemUseCase: ItemUseCaseProtocol

        init(itemUseCase: ItemUseCaseProtocol) {
            self.itemUseCase = itemUseCase
        }

    }

    final class ItemUseCase: ItemUseCaseProtocol {

        private let itemRepository: ItemRepositoryProtocol

        init(itemRepository: ItemRepositoryProtocol) {
            self.itemRepository = itemRepository
        }

    }

    final class ItemRepository: ItemRepositoryProtocol {

        private let remoteDataSource: ItemRemoteDataSourceProtocol

        init(remoteDataSource: ItemRemoteDataSourceProtocol) {
            self.remoteDataSource = remoteDataSource
        }

    }

    final class ItemRemoteDataSource: ItemRemoteDataSourceProtocol {

        private let networkClient: ItemNetworkClientProtocol

        init(networkClient: ItemNetworkClientProtocol) {
            self.networkClient = networkClient
        }

    }

    final class ItemNetworkClient: ItemNetworkClientProtocol {

        private let baseNetworkClient: BaseNetworkClientProtocol

        init(baseNetworkClient: BaseNetworkClientProtocol) {
            self.baseNetworkClient = baseNetworkClient
        }

    }

---

## Dependency Container

Wiring is done with [Factory](https://github.com/hmlongco/Factory) (`import FactoryKit`). Every module owns a
single `Sources/<Module>/Module+Factory.swift` that registers **its own** dependencies as an
`extension Container`. Nothing is registered from outside the module it belongs to.

- Presenters are the module's `public` surface — a `Factory<T>` when the screen takes no runtime
  parameter, a `ParameterFactory<P, T>` when it does. A presenter is `@MainActor`, so its factory
  property is annotated `@MainActor` too.
- **Presenter factories are never scoped.** The View owns the Presenter's lifetime; a `.cached` or
  `.scopeOnParameters` presenter would be shared between two Views.
- Every layer below the Presenter is `private` and resolved inside the factory closure, so a module's
  UseCases, Repositories, DataSources and Clients are invisible outside it.
- Scope a dependency only when it holds state in memory that must be shared. An `@Observable` store
  that keeps values in memory is `.cached`, so every module sees the same instance. A store that reads
  and writes `UserDefaults` on every call stays unscoped. System services are `.singleton`.
- A module that narrows a shared store to its own protocol (`ItemSettingsProtocol`) declares the store's
  conformance itself and passes the shared store straight in. The conformance never lives in the app target.
- **Avoid `promised()` wherever the module can resolve the dependency itself.** Anything from `Core`,
  `CoreUI` is resolved from that module's own public factory, never promised. A
  `promised()` factory is only for a dependency whose concrete type lives **above** the module, where
  the module cannot see it — the router, whose concrete type lives in the app target, is the standing
  case. The module declares a `promised()` factory for the routing protocol it owns and the app target
  registers it. `promised()` traps in DEBUG when a wire is missing, so a forgotten registration fails
  immediately and by name.
- **Avoid `MainActor.assumeIsolated`.** Make isolation known statically instead of asserting it at run
  time. The router is `@MainActor`, so it is created on the main actor — in the `@main` app's `init` —
  and that instance is registered with each module's routing factory from there. A `@MainActor` class is
  `Sendable`, so a factory closure can hand the instance out with no isolation hop. Use
  `assumeIsolated` only where no static alternative exists.
- If a module has its own type named `Container`, it spells Factory's as `FactoryKit.Container`.
- The app target keeps its own registrations in `App/DependencyInjection/`: `Container+App.swift` for
  app-level services, `Container+Routing.swift` for registering the router with every module's routing
  factory. `AppBootstrap` holds what runs once at launch and resolves what it needs from `Container.shared`.

Example:

    extension Container {

        // MARK: Presenters

        @MainActor
        public var itemListPresenter: Factory<ItemListPresenter> {
            self { ItemListPresenter(itemUseCase: self.itemUseCase, router: self.itemRouting()!) }
        }

        @MainActor
        public var itemDetailPresenter: ParameterFactory<Item.ID, ItemDetailPresenter> {
            self { itemID in ItemDetailPresenter(itemID: itemID, itemUseCase: self.itemUseCase, router: self.itemRouting()!) }
        }

        // MARK: Routing

        public var itemRouting: Factory<(any ItemRoutingProtocol)?> {
            promised()
        }

        // MARK: Use cases

        private var itemUseCase: any ItemUseCaseProtocol {
            self { ItemUseCase(itemRepository: self.itemRepository) }.resolve()
        }

    }

The app target registers the router once, on the main actor:

    extension Container {

        @MainActor
        func registerRouting(_ router: AppRouter) {
            itemRouting.register { router }
            settingsRouting.register { router }
        }

    }

    @main
    struct MyApp: App {

        private let router = AppRouter()

        init() {
            Container.shared.registerRouting(router)
        }

    }

---

## Presentation Layer

### View
- Each View has exactly one Presenter. No exceptions.
- The View resolves that Presenter from the container with `@InjectedObservable`, which builds it once on
  first body read and keeps it for the View's lifetime. Never build a Presenter inside `body` or pass one
  in through `init`.
- A View receives its screen's **parameters** by constructor (`ItemDetailView(itemID:)`) — never a
  Presenter, UseCase, Store or Service. A screen that needs no parameters has an empty `init()`.
- Views are passive — they only render state provided by the Presenter and report interactions back.
- Views never talk to UseCases, Repositories, DataSources, Stores or Services directly.
- A View never navigates; it sends an `Action` to its Presenter.

Example:

    public struct ItemListView: View {

        @InjectedObservable(\.itemListPresenter) private var presenter

        public init() {}

    }

    public struct ItemDetailView: View {

        @InjectedObservable private var presenter: ItemDetailPresenter

        public init(itemID: Item.ID) {
            _presenter = InjectedObservable(Container.shared.itemDetailPresenter(itemID))
        }

    }

### View Model & Action Extensions
- Every view that receives data defines its own `Model` as a nested struct inside an extension on the view.
- **A screen's models are the exception: they are standalone types.** The models a Presenter holds and
  hands to its screen's View are top-level types named for what they describe (`Question`, not
  `QuestionModel`), one per file in the screen's `Models/` folder — never nested in the screen's View.
  Their own nested types are declared in an extension of them. Components keep their nested `Model`.
- A screen that loads what it shows holds it in CoreUI's `ViewState` (`idle`, `loading`, `error`,
  `loaded`) — `ViewState<Question>` — rather than a loading enum of its own.
- Every view that produces user interactions defines its own `Action` as a nested enum inside an extension on the view.
- The Presenter is responsible for constructing the `Model` with all the data the view needs to render.
- **A View never sees a domain or data-layer model. Never.** Not as a property of its `Model`, not as
  an associated value of its `Action`, not as an `init` parameter — only its own `Model`, built from
  plain values (`String`, `Int`, `Bool`, `LocalizedStringResource`, `ImageResource`, `Color`) and its
  own nested types.
- Where a view needs an identity of its own, it declares a presentational type rather than borrowing
  the domain one — `ClockFace.Side`, not `Player`.
- Where an interaction must identify something, the `Model` carries its **id** and the `Action` hands
  the id back; the Presenter turns it into the domain value. An opaque id is the only domain-owned
  thing that may cross (see **Which Way A Model May Point**).
- **Layout variants are one view.** A screen's Compact and Regular views are two renderings of the same
  view, not two views. They share a single `Model` and `Action` declared on the **container**, and both
  take them as `Container.Model` / `(Container.Action) -> Void`. The container builds the model once and
  handles actions in one `onAction(_:)`. If a case genuinely applies to only one layout, it still
  belongs in the shared enum, and the other layout simply never sends it.

Example:

    struct ItemCard: View {

        let model: Model
        let action: (Action) -> Void

        var body: some View { ... }

    }

    extension ItemCard {

        struct Model: Identifiable {

            let id: Item.ID
            let title: String
            let subtitle: String
            let isSelected: Bool

        }

    }

    extension ItemCard {

        enum Action {

            case select(id: Item.ID)
            case delete(id: Item.ID)

        }

    }

### Presenter
- `@Observable`, `@MainActor`, named `<ScreenName>Presenter`, lives beside its View.
- Holds and exposes UI state to the View.
- Receives events from the View (`on…` functions — see `code-style.md`) and turns them into calls on
  a UseCase, a Service or the router.
- Maps UseCase models (ItemUseCaseModel) to view models (View.Model).
- Resolved by the View from the container as its concrete type. There is no `…PresenterProtocol`.

Example:

    func loadItems() async throws {
        items = try await itemUseCase.fetchItems()
            .map { ItemCard.Model(from: $0) }
    }

---

## Domain Layer

### UseCase
- One UseCase per feature concept (e.g., ItemUseCase for everything related to items). Do not create
  fat UseCases that span multiple unrelated features.
- Implements a protocol (e.g., ItemUseCaseProtocol) — only the protocol is visible to the Presenter.
- Contains business logic. Orchestrates Repositories and Services — or nothing, when the logic works on
  in-memory or computed data. Never a Store; a Store sits beside the UseCase, held by the Presenter.
- Trusts what is below it completely — never decides where data comes from.
- Maps Repository models (ItemRepositoryModel) to UseCase models (ItemUseCaseModel).

Example:

    func fetchItems() async throws -> [ItemUseCaseModel] {
        try await itemRepository.fetchItems()
            .map { ItemUseCaseModel(from: $0) }
    }

---

## Data Layer

Present only when a feature has data to fetch or sync. The Data Layer is composed of three components:
Repository, DataSource, and Client. Together they are the single source of truth for that data — it
enters the system here and nowhere else.

### Models
Each component in the Data Layer owns its models:
- ItemClientModel — raw model returned by the Client (e.g., decoded from JSON, BLE packet, etc.)
- ItemDataSourceModel — model owned by the DataSource, mapped from the Client model
- ItemRepositoryModel — model owned by the Repository, mapped from the DataSource model

Models never cross component boundaries without being explicitly mapped.

### Repository
- Implements a protocol (e.g., ItemRepositoryProtocol) — only the protocol is visible to the UseCase.
- Orchestrates one or more DataSources (e.g., remote, local database, Bluetooth).
- Single source of truth: the Repository decides which DataSource data comes from.
  Remote is the default. A local DataSource is only used when the feature explicitly
  requires it (e.g., offline support, user preferences).
- Maps DataSource models (ItemDataSourceModel) to Repository models (ItemRepositoryModel).

Example (remote as source of truth):

    func fetchItems() async throws -> [ItemRepositoryModel] {
        try await remoteDataSource.fetchItems()
            .map { ItemRepositoryModel(from: $0) }
    }

Example (local as source of truth, e.g. after sync):

    func fetchItems() async throws -> [ItemRepositoryModel] {
        let remoteItems = try await remoteDataSource.fetchItems()
        try await databaseDataSource.save(remoteItems)
        return try await databaseDataSource.fetchItems()
            .map { ItemRepositoryModel(from: $0) }
    }

### DataSource
- Implements a protocol (e.g., ItemRemoteDataSourceProtocol) — only the protocol is visible to the Repository.
- Each DataSource represents exactly one source of data:
  - ItemRemoteDataSource — fetches data over the network via ItemNetworkClient
  - ItemDatabaseDataSource — reads/writes to a local database (e.g., SwiftData, CoreData)
  - ItemBluetoothDataSource — receives data from a Bluetooth peripheral via ItemBluetoothClient
  - ItemFileDataSource — reads/writes data from the local file system
  - ItemKeychainDataSource — reads/writes secrets in the Keychain
- Local persistence of real data is always a DataSource below a Repository, never a Store.
- Holds a reference to its underlying Client via constructor injection. Responsible only for
  data retrieval and storage — no business logic.
- Maps Client models (ItemClientModel) to DataSource models (ItemDataSourceModel).

Example:

    func fetchItems() async throws -> [ItemDataSourceModel] {
        try await networkClient.fetchItems()
            .map { ItemDataSourceModel(from: $0) }
    }

### Client
- A feature-specific Client (e.g., ItemNetworkClient) exposes named, intent-driven functions
  (e.g., fetchItems(), createItem(_:)). This is the only interface visible to the DataSource.
- Implemented behind a protocol (e.g., ItemNetworkClientProtocol).
- Holds a reference to the corresponding BaseClient via constructor injection and delegates
  the actual execution to it.
- Maps the raw response from BaseClient into Client-level models (e.g., ItemClientModel).
- Each Client type has a corresponding base abstraction:
  - ItemNetworkClient holds BaseNetworkClient (abstraction over URLSession)
  - ItemBluetoothClient holds BaseBluetoothClient (abstraction over CoreBluetooth)
- No business logic lives in the Client — only request construction and model mapping.

Example:

    protocol ItemNetworkClientProtocol {
        func fetchItems() async throws -> [ItemClientModel]
    }

    func fetchItems() async throws -> [ItemClientModel] {
        try await baseNetworkClient.execute(ItemEndpoint.fetchAll)
            .map { ItemClientModel(from: $0) }
    }

    protocol BaseNetworkClientProtocol {
        func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    }

    func execute<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try buildRequest(from: endpoint)
        let (data, _) = try await session.data(for: request)
        return try decoder.decode(T.self, from: data)
    }

---

## Navigation

A feature does not know where it sits in the app. It declares **what it needs to be able to do**, and
something above it obliges.

- Each module owns one routing protocol in `Sources/<Module>/Common/Navigation/` —
  `ItemRoutingProtocol`. It is the one file in a feature the app target must know about.
- The protocol belongs to the **module**, not to a screen: it says how the app enters and leaves the
  feature, and it serves every screen the module grows. Name methods by intent —
  `navigateToDetail(itemID:)`, `navigateBack()` — not by the gesture that triggered them (`rowTapped()`).
- The Presenter takes it through the constructor, like any other dependency, and calls it.
- The app target owns a single `@Observable` `AppRouter` that holds the navigation state and conforms
  to each module's routing protocol in its own `// MARK:` extension. The `@main` app creates the one
  instance and registers it with each module's routing factory (see **Dependency Container**).

Feature modules therefore never import each other, and a feature can be presented from anywhere
that can satisfy its protocol.

---

## Which Way A Model May Point

Each layer owns its models and maps at the boundary. Where that bites is the direction a reference
points.

**A layer may name types from the layers below it.** A UseCase model holding a domain identifier or a
domain value type is fine: those are types it was built from, encapsulated by the UseCase model, not
leaked by it.

**A layer may never name a type from a layer above it.** A UseCase model holding a presentation model
(anything render-ready — images, colors, sizes, SwiftUI types) is wrong however convenient, because
the domain then depends on how a screen happens to draw. Keep the domain value on the UseCase model
and let each Presenter turn it into what its view draws.

### Opaque identifiers are exempt

An identifier may cross any boundary unmapped, including into the routing protocols, where
`navigateToDetail(itemID: Item.ID)` carries one out of a presenter and back again. Nothing reads into
it — it is handed out and handed back — so a mapped twin would be converted twice on every
navigation with no reader.

A structure is not an identifier. The moment something is read into, it is mapped.

---

## Rules

- A screen gets only the layers that have a job. No pass-through layers.
- Every dependency below the Presenter goes through a protocol. The View → Presenter edge is concrete.
- All dependencies are injected through the constructor. No component creates its own dependencies.
  The View is the one exception: it resolves its Presenter from the container and takes only its
  screen's parameters by constructor.
- Each module registers its own dependencies in `Sources/<Module>/Module+Factory.swift`, and only its own.
  Presenter factories stay unscoped; everything below the Presenter stays `private` to the module.
- Never skip a layer that exists. A View cannot talk to a UseCase; a Presenter cannot reach past its
  UseCase to a Repository.
- A Store is a `UserDefaults` store at UseCase level, held by the Presenter. A UseCase never holds a
  Store. Persistence of real data — database, files, Keychain — is a DataSource.
- Avoid `promised()` unless the dependency's concrete type lives above the module. Avoid
  `MainActor.assumeIsolated`; make isolation static instead.
- Models may point down, never up. Opaque identifiers are exempt.
- **A domain or data model never reaches a View** — not in a `Model`, not in an `Action`, not as a
  parameter. Identity crosses as an id.
- Single source of truth at every layer. Each layer has one designated source it trusts — it never
  reaches sideways or pulls from multiple sources on its own.
- One UseCase per feature concept. One Presenter per View.
- Repository decides the source of truth. Remote is the default; local is only used when
  the feature explicitly requires it.
- Feature modules never import each other. Communication goes through a routing protocol the app satisfies.
