# Architecture

> Skeleton from M1. Each milestone fills in its part.

## Big picture
```
[Caspian Warehouse (Windows, MariaDB)] --push events / poll decisions--> [Middle server (future)] <--HTTPS /v1--> [Caspian Owner app]
```
- The **Warehouse app is the source of truth** for items, stock, persons, locations and documents.
- The owner app talks **only to the middle server** through the contract `api/openapi.yaml` (OpenAPI 3.1, `/v1/...`). Until the server exists, mock repositories return contract-valid data. Switching to the real server changes one config value.

## Warehouse ↔ server sync (document only, not built here)
- The **Warehouse always initiates** the connection: it pushes events from its outbox, then polls the server for owner decisions and count orders.
- **No port is ever opened on the mall network.**
- Server plan: an Iranian VPS, FastAPI + PostgreSQL/MariaDB.
- Outbox events: `locations.snapshot`, `stock.snapshot`, `request.created`, `request.decided` (including manager decisions), `voucher.issued`, `count.ordered`, `count.result`.
- An issue voucher (حواله خروج) for an escalated request can't be posted in the Warehouse until the request is approved. The first owner decision wins (`409` for later ones).

## App layers
- `lib/features/<feature>/presentation`: widgets + Riverpod notifiers.
- `lib/features/<feature>/domain`: immutable models, repository interfaces.
- `lib/features/<feature>/data`: mock and API implementations.
- `lib/core/`: brand, config, theme, l10n, router, network, storage, security, update, notifications, modules, logging, widgets, utils.

## Offline behaviour
- Last data cached in drift, shown with «آخرین به‌روزرسانی: …».
- Offline decisions go to a pending queue («در صف ارسال»), each with an idempotency key, so the server applies it only once.

## Modules
An `AppModule` registry lets other Caspian apps (parking, services, CRM) contribute Home cards, More entries and routes, enabled per role through server feature flags (mocked now).

## Android specifics
- applicationId `com.alirezamolayari.caspianowner` (permanent). minSdk 24 (Flutter 3.47.7's floor), targetSdk 36.
- Release signing from `android/key.properties` (git-ignored); falls back to the debug key with a warning.
- No Google Play Services or Firebase. Notifications use a workmanager poll; the APK updates itself (see RELEASING.md).
