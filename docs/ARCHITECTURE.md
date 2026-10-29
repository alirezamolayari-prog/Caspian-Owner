# Architecture

> Skeleton from M1. Each milestone fills in its part.

## Big picture
```
[Caspian Warehouse (Windows, MariaDB)] --push events / poll decisions--> [Caspian Server (FastAPI)] <--HTTP(S), polling /changes--> [Caspian Owner app]
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
- **Switch to the real server:** `core/config/api_config.dart`, one value (`ApiConfig.dataSource`). Since M15 the app uses `DataSource.api`; tests use the mock through `dataSourceProvider` (overridden by `TestHarness`).

## Caspian Server v1 (M15)
The first real middle server is **Caspian Server** (FastAPI, repo `alirezamolayari-prog/Caspian-Server`, API in its `/docs` and `/openapi.json`). It is much simpler than `api/openapi.yaml`, which stays as the long-term contract (and `contract_test.dart` still guards the models against it).

| Owner app | Caspian Server v1 |
|---|---|
| `AuthRepository.login` | `POST /auth/login` (form `username` = mobile `09…` or username, `password`) → JWT (7 days, no refresh), then `GET /auth/me`. Only `owner`/`admin` roles may sign in (`not_owner`). `must_change_password` → `MustChangePasswordException` (no `/auth/me`: the server refuses it until the change). |
| `AccountRepository` (M16) | `POST /auth/otp/request`, `/auth/otp/verify`, `/auth/otp/register`, `/auth/otp/reset-password`, `/auth/change-password`, exactly as Caspian-Server `docs/owner-auth-api.md`. SMS login (`purpose: login`) is off and never used. |
| `RequestsRepository.list/get` | `GET /requests[?status=]`, `GET /requests/{id}` (+ `GET /requests/{id}/messages` for the chat summary) |
| `decide` approve / reject | `POST /requests/{id}/approve`, `POST /requests/{id}/reject {reason}`. No idempotency keys: a retried decision answered `409` counts as applied when `decided_by_id` is us. `returnForEdit` is not on the server (hidden). |
| `ChatRepository` | `GET`/`POST /requests/{id}/messages` (whole chat; pages cut in the app) |
| live updates | `GET /changes?since=` every 5 s while the app is visible (`core/sync/live_sync.dart`); first `since` from `GET /health` (server clock). Upsert by id: answers overlap 2 s. |
| background notifications | the same `/changes` from workmanager (`ApiNotificationSource`) |
| stock, assistant, reports, `/notifications`, `/config`, `/locations` | not on the server yet: «به‌زودی» pages (`ServerFeatureGate`), `NotConnected*` repositories, `LocalConfigRepository` |

- `core/network/api_client.dart`: dio wrapper; adds the token; maps failures to `ApiException`. No answer → `NetworkException` (`offline` when the host name can't be looked up: «اینترنت گوشی وصل نیست», else «سرور کاسپین جواب نداد»). A `401` on a signed-in request signs out (`SignOutReason.sessionExpired`). Account errors (`X-Error-Code` on requests without a token, any `429`, `password_change_required`) → `ServerException(code, messageFa: detail, retryAfter)`; screens switch on the code and show the server's Persian `detail`. FastAPI's 422 list → `ValidationException.fieldErrors` (`loc[1]` → message). Other signed-in errors keep their types (401/403/404/409/422).
- `core/network/server_mappers.dart`: server JSON → app models. Server ids become string ids and request numbers; the place is free text (`consumption_location`, no floor); every request is escalated; times are UTC on the wire and local in the app.
- `serverCapabilitiesProvider` hides what v1 doesn't send (stock row, same-place history, return for edit).
- **Server address:** `ApiConfig.defaultServerUrl` = `https://api.caspianmoblserver.ir`. Release builds always use it (any saved address is ignored). Debug builds can change it (Settings, login screen; `ApiConfig.serverUrlEditable`).
- **Plain HTTP:** debug builds only. `ApiConfig.allowLanHttp` (= `!kReleaseMode`) lets `http://` through for private-network hosts, and `src/debug/res/xml/network_security_config.xml` permits cleartext; `src/main` (release) is https only.

## Accounts (M16, v0.4.0)
Register, login, forgotten password and first-password change, for owners aged 55–65: big text (18 sp inputs), 56 dp buttons, one main action per page, step «مرحله ۲ از ۳», Persian messages from the server.

- Pages (`features/auth/presentation/`): `LoginScreen` (mobile, or username for admins; a value with Latin letters is a username), `RegisterScreen` → `OtpScreen` → `NewPasswordScreen` → `AccountStatusScreen(registered)`; `ForgotPasswordScreen` → `OtpScreen` → `NewPasswordScreen(reset)` → login; `AccountStatusScreen` for `account_pending/rejected/disabled`; `NewPasswordScreen(changeFirst)`; `UnlockOfferScreen`. Shared pieces in `widgets/auth_page.dart`. Mobile numbers are shown with `IranMobile.display`: Persian digits, grouped, inside a left-to-right isolate (U+2066 … U+2069) so the groups keep their order in Persian text.
- State (`application/account_flow.dart`), memory only: `AccountFlow` (purpose, mobile, names, `resendAt`, `verifiedToken`), `LoginHint` (mobile + notice for the login page), `PasswordChange` (token + current password until the change).
- Rules on the phone first (`core/utils/iran_mobile.dart`, `domain/account_rules.dart`): mobile forms `09…`, `9…`, `+98…`, `0098…` with Persian/Arabic digits → `09XXXXXXXXX`; Persian names 2–50, ي/ك → ی/ک; password ≥ 8 characters, ≤ 72 bytes, ≥ 4 different, not common.
- Resend: «ارسال دوباره کد» after `resend_after`; a `429` restarts the countdown from `Retry-After`. Since v0.4.1 the server answers `/auth/otp/request` with 200 only when Shahmiz accepted the SMS; otherwise `409 mobile_taken` (register → «ورود» / «رمز را فراموش کرده‌ام» with the number filled in), `404 account_not_found` (reset → «ثبت‌نام»), `403 account_disabled/rejected`, `503 sms_not_sent`. `errorMessage` has the app's own wording for these. Login `429` disables «ورود» with a countdown.
- **SMS User Consent** (`core/sms/sms_code_listener.dart` ↔ `SmsConsent.kt`, channel `caspian/sms_consent`): Android asks once to read that one SMS; no SMS permission. The consent intent is only started if it resolves to `com.google.android.gms` without URI grants. Declined, no Google Play services or timeout → null, the owner types. Tests use `FakeSmsListener`.
- **Lock:** after a password login (`SignedOut → SignedIn`), `LockState.offerPending` routes to `/unlock-offer`. Yes → one device prompt, `SecureKeys.deviceUnlock = on`. «فعلاً نه» → `off` → app PIN setup. The choice is wiped on logout; Settings has a switch. Device unlock only opens the stored session; a `401` still means password login. The lock screen has «ورود با رمز عبور» (signs out).
- Routes open while signed out: `isSignedOutPath` in `core/router/routes.dart`.

## Requests on Caspian Server (v0.4.2)
- Statuses: `pending`, `approved`, `rejected`, `issued` («حواله صادر شد», with `issue_number`). Anything else → `RequestStatus.unknown` («نامشخص»), logged through `ServerMappers.warn`, never decidable. Waiting counts (home, hub badge, «منتظر» tab) use `canDecide` = escalated and pending.
- Who decided is never sent (privacy): `decided_by_me` → `DeciderKind.me` («شما») or `anotherOwner` («یکی از مالکان»); see `widgets/decider_name.dart`. Chat: the warehouse keeps its name, owners are «شما» / «مالک».
- Item codes come from `item_code` (empty → hidden), not the row id.
- Reject needs a reason (server `RejectIn.reason`, ≥3 letters in the sheet).
- Decision queue: refusals for good (400/403/404/422) are dropped and reported (`FlushResult.failed` → `decisionFailureProvider` → SnackBar); network, 401, 408, 429 and 5xx stay queued. `reconcile()` at sign-in drops decisions whose request is no longer pending.
- Release builds replace Flutter's grey error box with `FriendlyErrorWidget`; the error goes to the on-device log.

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
- No Google Play Services or Firebase, **except `com.google.android.gms:play-services-auth-api-phone`** (SMS User Consent, approved by Alireza for M16; brings only play-services-base/basement/tasks). Phones without Google Play services simply type the code. Notifications use a workmanager poll; the APK updates itself (see RELEASING.md).
