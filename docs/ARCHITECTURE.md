# Architecture

> Skeleton from M1. Each milestone fills in its part.

## Big picture
```
[Caspian Warehouse (Windows, MariaDB)] --push events / poll decisions--> [Middle server (future)] <--HTTPS /v1--> [Caspian Owner app]
```
- The **Warehouse app is the source of truth** for items, stock, persons, locations and documents.
- The owner app talks **only to the middle server** through the contract `api/openapi.yaml` (OpenAPI 3.1, `/v1/...`). Until the server exists, mock repositories return contract-valid data. Switching to the real server changes one config value.

## Warehouse ↔ server sync (document only, not built here)
- The **Warehouse always initiates** the connection: it pushes events from its outbox, then polls the server for owner decisions (count orders were removed from the owner app in v0.2.0).
- **No port is ever opened on the mall network.**
- Server plan: an Iranian VPS, FastAPI + PostgreSQL/MariaDB.
- Outbox events: `locations.snapshot`, `stock.snapshot`, `request.created`, `request.decided` (including manager decisions), `voucher.issued`, `count.ordered`, `count.result`.
- An issue voucher (حواله خروج) for an escalated request can't be posted in the Warehouse until the request is approved. The first owner decision wins (`409` for later ones).

## App layers
- `lib/features/<feature>/presentation`: widgets + Riverpod notifiers.
- `lib/features/<feature>/domain`: immutable models, repository interfaces.
- `lib/features/<feature>/data`: mock and API implementations.
- `lib/core/`: brand, config, theme, l10n, router, network, storage, security, update, notifications, modules, logging, widgets, utils.

## Data layer (M3)
- **Contract:** `api/openapi.yaml`. Beyond the minimum schemas it adds `GoodsRequest.escalated` (owners decide only escalated requests; routine ones are shown read-only), `AlreadyDecided` (the `409` body carrying the winning decision), `LocationUsage` (same-place history), `NotificationEvent` (with an in-app deep-link `target`) and `Location.merged_with`.
- **Models:** freezed classes per feature (`features/*/domain/`), shared ones in `core/domain/` (people, places, config).
- **Repositories:** interfaces in `features/*/domain/*_repository.dart`; failures are the sealed `ApiException` family (`core/network/api_exception.dart`).
- **Mock backend:** `core/mock/`. One in-memory server (`MockBackend`) loads the JSON fixtures in `assets/mock/` through the contract models, shifts their dates to "now", and applies the server's rules: first decision wins (`409`), idempotency keys, items the Warehouse app is counting hide their stock, stock never auto-adjusted. Scenarios for the developer screen: normal, empty, slow network, server error, conflict.
- **Locations:** `assets/mock/caspian_locations.csv` is the Warehouse seed file, byte-identical to commit `2f26c614` on `feature/a-consumption-locations` of `Caspian_Warehouse`. Re-sync from `main` after that branch is merged. Floors and their display names live in `core/domain/place.dart` (`Floors.all`, building order P4 → ROOF).
- **Switch to the real server:** `core/config/api_config.dart`, one value (`ApiConfig.dataSource`).

## Offline behaviour
- Last data cached in drift, shown with «آخرین به‌روزرسانی: …».
- Offline decisions go to a pending queue («در صف ارسال»), each with an idempotency key, so the server applies it only once.
- Implementation: `core/storage/` (drift). `CacheStore` keeps contract JSON per key with its time. `PendingDecisionQueue`: every decision is enqueued, then flushed. At most one entry per request (a newer decision replaces an unsent one); `409` removes it and reports the winner; offline keeps it and stops the flush; the same key is reused on every retry. `AppDatabase.wipe()` runs on logout.

## Modules
The app opens on the **«کاسپین» hub** (`/`): one tile per Caspian module. Each active module has **its own bottom tabs (max 4)**. The owner app only gets *partial* access to each Caspian app (approvals, overviews, chat), never the full app.

- `core/modules/app_module.dart`:
  - `AppModule` has `id`, `title`, `subtitle`, `icon`, `tabs` (`ModuleTab`: label, icon, path, builder, sub-routes), `badge(ref)` for the hub tile, and `moreEntries`.
  - `ComingSoonModule` is an announced module without screens: a «به‌زودی» tile that opens `/m/:id`.
- `moduleRegistryProvider` lists the compiled modules: `WarehouseModule` (`lib/features/warehouse_module.dart`) plus parking, CRM and services as coming soon.
- The server decides what is shown: `AppConfig.modules` (active) and `AppConfig.upcomingModules` (coming soon), mocked in `assets/mock/config.json`. Anything else is hidden.
- The router builds one `StatefulShellRoute` per module from its tabs, so a real module plugs in without touching the shell or the hub.
- `ModuleShell` draws the module's tabs. Android Back on another tab goes to the first tab, and from the first tab back to the hub.
- Tab screens use `ModuleAppBar`: the module name, the page title, and a button back to the hub.
- More, Settings, About, notifications and the avatar are global, reachable from the hub and from inside modules.
- Paths are stable: the warehouse tabs keep `/requests`, `/stock` and `/assistant` (notification links since v0.1.0); only its Home moved from `/` to `/warehouse`. Pages that should cover the tabs attach to `rootNavigatorKey` (`core/router/navigator_keys.dart`).

## Android specifics
- applicationId `com.alirezamolayari.caspianowner` (permanent). minSdk 24 (Flutter 3.47.7's floor), targetSdk 36.
- Release signing from `android/key.properties` (git-ignored); falls back to the debug key with a warning.
- No Google Play Services or Firebase. Notifications use a workmanager poll; the APK updates itself (see RELEASING.md).
