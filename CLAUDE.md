# CLAUDE.md — Caspian Owner

**Start every session by reading `docs/PROGRESS.md`.** Its first line says what to do next.

## What this is
Private Android app (Flutter) for the ~5 owners of Caspian furniture mall (building **Phase 2** only). Owners approve **escalated** goods requests from the Caspian Warehouse desktop app, see stock, order **surprise counts** (شمارش غافلگیرانه), chat per request, and use a mock AI assistant «دستیار کاسپین». Owner and developer: **Alireza Molayari** (not a programmer; he tests by using the app). Report to him in short, plain language.

- The **Warehouse app** (`alirezamolayari-prog/Caspian_Warehouse`: Python, PySide6, MariaDB) is the source of truth. This app talks **only to a future middle server**, never to the warehouse DB. Until the server exists, everything runs on **mock repositories** that follow `api/openapi.yaml` exactly. Switching to the real server = one config value.
- Request rules: routine requests are approved in the Warehouse app; important ones (amount/qty threshold, important item, manual) are escalated to owners. **The first decision wins**; the others see «تأیید شد توسط <name>» (server answers `409`).
- Surprise count: starts immediately; items are locked and their stock is hidden from everyone (`qty: null`, `locked_by_count`) until staff count. Results show system vs counted qty, every entry, who counted. **Stock is never auto-adjusted.**
- Places are always `location_code` + `floor_code`, never internal ids. Floors in building order: P4, P3, P2, P1, B (زیرهمکف), G (همکف), F1, F2, F3, ROOF (بام).

## Stack and environment
- Flutter **3.47.7** stable (Dart 3.13.5) at `E:\dev\flutter`; JDK 17 (`C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot`); Android SDK `E:\dev\android-sdk` (managed with the new `android sdk` CLI in `cmdline-tools\latest\bin`; always pass `--no-metrics`).
- Caches on E: `PUB_CACHE=E:\dev\.pub-cache`, `GRADLE_USER_HOME=E:\dev\.gradle`. Drive C is low on space; install nothing there.
- Network is filtered (Iran). If a download returns 403 or times out twice, stop and ask Alireza to turn on his VPN. Never disable TLS checks. Never add mirrors to Gradle files without asking.
- applicationId **`com.alirezamolayari.caspianowner`**: permanent, never change it. minSdk 24, targetSdk 36.
- Riverpod, go_router (`StatefulShellRoute`, 4 tabs), dio, freezed/json_serializable, drift, shamsi_date, intl. Package pins and reasons are in `docs/ARCHITECTURE.md`.
- **Forbidden:** Google Play Services, Firebase, google_fonts, Crashlytics/analytics, anything fetching assets at runtime. Bundle everything.

## Commands
```powershell
flutter pub get
dart run build_runner build      # after changing models (freezed/json) or the drift database
dart format .
flutter analyze --fatal-infos
flutter test
flutter build apk --debug
flutter build apk --release   # signed with android/key.properties, else the DEBUG key + warning
```

## Quality gate (before every push)
`dart format --set-exit-if-changed .` → `flutter analyze --fatal-infos` (zero issues) → `flutter test` (all green) → `flutter build apk --release`. If a phone is connected: install, launch, screenshots to `docs/screenshots/`.

## Git workflow
- `main` is always releasable. One branch per milestone `m<NN>-<short-name>`; small English commits; `gh pr create`; wait for CI; `gh pr merge --squash --delete-branch` only when green.
- Never force-push `main`, never rewrite published history, never commit build outputs or secrets.
- After every milestone update `docs/PROGRESS.md` (keep "Next step:" accurate).

## Code conventions
- Dart 3.13 constructor syntax: `const new(...)`, `const factory(...)`, `factory fromJson(...)` (lint `unnecessary_type_name_in_constructor`). `dart fix --apply` converts old-style code.
- Models are freezed + json_serializable with snake_case keys (`build.yaml`). Fields that are required-but-nullable in the contract need `@JsonKey(includeIfNull: true)`. Digits in names need an explicit `@JsonKey(name: ...)` (e.g. `used_last_30d`).
- `test/contract/contract_test.dart` validates every model against `api/openapi.yaml`. Keep it green when changing either side.
- Generated files (`*.g.dart`, `*.freezed.dart`, `lib/core/l10n/generated/`) are committed.
- Riverpod 3 with plain providers (no generator). Dependencies are injected in `lib/core/di/providers.dart` and overridden at startup by `lib/bootstrap.dart`; tests use `test/helpers/test_app.dart` (`TestHarness`). `ProviderScope(retry: ...)` returns null: no silent automatic retries.
- Widget tests: never do real file I/O inside `testWidgets` (it hangs on the fake clock). Load fixtures in `setUpAll` (`loadTestFixtures()`), then `TestHarness.create(fixtures, ...)`. Run long suites with `--timeout 60s`.
- Test databases use `DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true)`; otherwise drift's stream-closing timer fails widget tests ("A Timer is still pending").
- `tester.pageBack()` can't find the back button since Material moved to its own package; use `tester.binding.handlePopRoute()` (Android back).
- With several scrollables on screen (e.g. a multi-line TextField), pass `scrollable: find.byType(Scrollable).first` to `scrollUntilVisible`.
- Android: `MainActivity` must stay a `FlutterFragmentActivity` (local_auth), with an AppCompat launch theme.
- Never run other `flutter` commands while `flutter build apk --release` runs: they regenerate `GeneratedPluginRegistrant.java` with dev-only plugins (`integration_test`) and the release compile fails ("package dev.flutter.plugins.integration_test does not exist").
- Edit text files with the editor tools, not Windows PowerShell `Get-Content`/`Set-Content` (they mangle UTF-8).

## Architecture rules
- Feature-first: `lib/features/<name>/{data,domain,presentation}`; shared code in `lib/core/`.
- presentation (widgets + Riverpod notifiers) → domain (immutable models, repository interfaces) → data (mock + API implementations).
- Offline-tolerant: cache last data and show «آخرین به‌روزرسانی: …»; offline decisions go to a drift **pending queue** («در صف ارسال»), each with an **idempotency key**.
- Modules: an `AppModule` registry contributes Home cards, More entries and routes; enabled per role via server feature flags (mocked).
- Branding lives in **one place**: `lib/core/brand/brand.dart` plus Android resources (the product will be renamed and resold).

## UI rules
- Follow the approved UI spec: exactly 4 bottom tabs (خانه · درخواست‌ها · موجودی · دستیار); everything rare goes in More (from the avatar). One primary action per screen.
- Colors only from the theme tokens (no hex in widgets). Light and dark themes; follow the system.
- RTL everywhere, Persian digits, Jalali dates, relative times. **All strings in ARB files**; no hard-coded text in widgets.
- 48dp touch targets, contrast ≥ 4.5:1, status always as text (never color alone), no swipe-only actions, semantic labels on icon buttons, must work at the largest system font size.
- Separator in visible text is « – » (en dash), never «·»: next to Persian digits the middle dot reads as Persian zero («۲۴ · عدد» looks like «۲۴۰ عدد»). So the UI spec's «پلاک ۶۸ · همکف» is shown as «پلاک ۶۸ – همکف».
- Long lists are lazy (`ListView.builder` / `SliverList.builder` with `CardSegment` for the grouped-card look).
- `test/features/accessibility_test.dart` checks tap targets, labels and contrast on the main screens; add new screens to it.
- Use the `ui-ux-pro-max` skill for UI decisions (`--stack flutter`, `--domain ux`).

## Updates and release
- Local release builds: `flutter build apk --release --target-platform android-arm,android-arm64` (as CI does; owners' phones are ARM). `android/gradle.properties` sets in-process Kotlin with `kotlin.incremental=false` for this PC.
- Release builds need the `INTERNET` permission in `src/main/AndroidManifest.xml` (Flutter's template only grants it to debug/profile).
- `pubspec.yaml` `version: X.Y.Z+BUILD`; BUILD must always increase. Use `tool/bump_version.ps1`.
- In-app updater (`lib/core/update/`) reads `update.json` (server URL first, then the GitHub Release asset), verifies SHA-256, then starts the installer.
- The release keystore lives **only** on Alireza's PC (`E:\keys\`, KeePassXC, 3 backups) and in GitHub Actions secrets. If it's lost, the app can never be updated. Never read, print or commit it.
- Release: tag `vX.Y.Z` → `.github/workflows/release.yml` builds the signed APK, makes `update.json`, publishes a GitHub Release. See `docs/RELEASING.md`.

## Security
- No secrets in the repo, logs, commit messages or chat. `.gitignore` covers `key.properties`, `*.jks`, `*.keystore`, `local.properties`, `build/`, `.env*`.
- HTTPS only (cleartext blocked in release). Tokens only in `flutter_secure_storage`. Wipe local data on logout. Every decision sends `idempotency_key`, device id and app version.
- Release builds: R8 on, debug-only menus stripped, reduced logging. Developer screen (7 taps on the version in About); mock/API switch and base URL only in debug builds.

## Docs
`docs/ARCHITECTURE.md` · `docs/RELEASING.md` · `docs/ROADMAP.md` · `docs/PROGRESS.md` · `docs/CHANGELOG.md` · `docs/USER_GUIDE_fa.md`
