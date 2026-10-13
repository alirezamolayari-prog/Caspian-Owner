# Progress

**Next step:** M12 PR is open (branch `m12-updates`). Wait for green CI, squash-merge with `gh pr merge <n> --squash` (no `--delete-branch`; delete branches by hand), then start M13 (final QA: tab goldens with a fixed clock, accessibility and large-text sweep, list performance, USER_GUIDE_fa.md, CHANGELOG, tag v0.1.0 — the signing secrets exist) on branch `m13-final-qa`.

## Environment (M0)
| Item | Value |
|---|---|
| Flutter | 3.47.7 stable (Dart 3.13.5) at `E:\dev\flutter` |
| JDK | Microsoft OpenJDK 17.0.20 at `C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot` (`flutter config --jdk-dir`) |
| Android SDK | `E:\dev\android-sdk`, managed with the **new `android` CLI** (`cmdline-tools\latest\bin\android.exe`; the CLI itself lives in `~\.android\bin`). `sdkmanager` is deprecated. Always pass `--no-metrics`. Packages: platform-tools, platforms/android-36, platforms/android-37.0, build-tools/36.1.0, ndk/28.2.13676358 |
| Caches | `PUB_CACHE=E:\dev\.pub-cache`, `GRADLE_USER_HOME=E:\dev\.gradle` |
| KeePassXC | 2.7.12 |
| Old, untouched | `C:\src\flutter` (3.44.6, removed from the System PATH), old SDK in `%LOCALAPPDATA%\Android\Sdk`, Android Studio. Deleting the first two would free ~3.3 GB on C (Alireza's choice) |

Shells started before M0 don't see the new user env vars. Set them inline, or open a new terminal.
Flutter 3.47.7 floor: **minSdk 24** (Android 7.0). targetSdk 36.
Windows PowerShell 5.1 mangles UTF-8 when it rewrites files: edit text files with the editor tools, not `Get-Content`/`Set-Content`.

## Milestones
| # | Status | Notes |
|---|---|---|
| M0 | Done | `flutter doctor` green (Flutter + Android, licenses accepted); no phone connected |
| M1 | Done (PR #1) | Scaffold, signing, lints, LICENSE, CLAUDE.md, docs, CI |
| M2 | Done (PR #2) | Brand, light/dark tokens, Vazirmatn UI-FD bundled, fa/RTL, ARB + gen-l10n, Persian digits, Jalali, relative time, StatusChip, AppIcons |
| M3 | Done (PR #3) | `api/openapi.yaml`, freezed models, repository interfaces, mock backend + fixtures (scenarios), locations CSV, drift cache + pending queue, ApiConfig switch, module registry |
| M4 | Done (PR #4) | Login (phone + OTP, `11111` in debug only), session in secure storage, app lock (fingerprint/device PIN; app PIN fallback; 5 wrong PINs → sign out), go_router shell with 4 tabs + deep links through the lock, FLAG_SECURE channel, logout wipes data |
| M5 | Done (PR #5) | Home: hero card, latest 3 requests, surprise-count card; skeleton, error + retry, pull-to-refresh, offline cache; mock `offline` scenario |
| M6 | Done (PR #6) | Requests tab + Request Detail, approve with fingerprint + 5 s undo, reject with reason, offline queue, 409 dialog, chat, same-place history; acceptance flow login → approve → «بررسی‌شده» |
| M7 | Done (PR #7) | Stock tab: search, «کم‌موجود», hidden counts, movements sheet; large-text fixes |
| M8 | Done (PR #8) | Surprise count: pick + confirm, status/results (difference in words + icon, every entry), history |
| M9 | Done (PR #9) | Assistant (mock): suggestions (wrapping), history sheet, thinking/failed states |
| M10 | Done (PR #10) | More via module registry, reports by floor/location, persistent settings, About + developer screen, on-device log |
| M11 | Done (PR #11) | workmanager 15-min poll → local notifications (shown once per event) → deep link through the lock; permission on login/enable |
| M12 | PR open | In-app updates: manifest URL fallback, optional dialog (from the tab shell) / blocking screen, resumable download + SHA-256 check + cleanup, installer channel (FileProvider), install-permission explanation, About «بررسی به‌روزرسانی»; `tool/bump_version.ps1`, `tool/make_update_manifest.dart`, `release.yml` (ARM-only signed APK + update.json + notes), RELEASING.md; HTTPS-only network config (pinning prepared), **INTERNET permission added to release**; 225 tests; dry-run update.json verified |
| M13 | Not started | Tab goldens (requests/stock/assistant) planned with a fixed clock |

## Human checklist status (§2.4)
- [x] H1 UAC prompts (JDK 17, KeePassXC)
- [x] H2 removed `C:\src\flutter\bin` from the System PATH
- [x] H3 licenses: the new `android sdk` CLI shows the terms without a prompt; `flutter doctor` reports all licenses accepted
- [x] H4 release keystore `E:\keys\caspian-owner-release.jks` (alias `caspian-owner`), in KeePassXC + backups
- [x] H5 `android/key.properties` (git-ignored)
- [x] H6 GitHub secrets KEYSTORE_BASE64, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD
- [ ] H7 (optional) phone connected

## Open problems / notes
- Harmless build warning: the new `android sdk` CLI writes package.xml v4, AGP reads up to v3 ("SDK processing ... XML version 4"). Builds succeed.
- The Kotlin daemon can't start on this PC, so `android/gradle.properties` sets `kotlin.compiler.execution.strategy=in-process`. Gradle heap lowered to 3G (the PC has 8 GB RAM).
- Release APK signing verified: cert SHA-256 `f332c7e7…c468ec` (full value in docs/RELEASING.md).
- Dart 3.13 constructor syntax `const new(...)` is used (the lint `unnecessary_type_name_in_constructor` wants it). VS Code's Dart extension shows a false "primary-constructors experiment" error until VS Code is restarted and picks up Flutter 3.47.7 from `E:\dev\flutter`.
- Material Symbols fonts are only tree-shaken once app code (not just tests) uses an icon. M2's release APK is 56.5 MB for that reason; with one icon used it's 41.9 MB. Recheck the size after M5.
- Goldens: `test/**/goldens/ci/` (all platforms) and `goldens/windows/` (local only). Regenerate with `flutter test --update-goldens`.
- `build_runner` 2.16 removed `--delete-conflicting-outputs`; plain `dart run build_runner build`.
- `csv` 8.0.0 API: `Csv(autoDetect: false).decode(text)` (auto-detect off: the `;` in aliases could fool it).
- A local `.vscode/settings.json` (excluded via `.git/info/exclude`) points the Dart extension at `E:\dev\flutter`; this removed the false IDE errors.
- Release APK is ~57 MB: one "fat" APK with native code for arm64, armv7 and x86_64, plus SQLite. Consider dropping x86_64 or splitting per ABI in M12 (download size on slow networks).
- Release builds take 15–20 minutes on this PC; run them in the background.
- Widget tests: ListView doesn't build off-screen items; use `scrollUntilVisible` before expecting them. Goldens with relative times: add ~30 s slack so «۱۰ دقیقه پیش» doesn't round to ۹.
