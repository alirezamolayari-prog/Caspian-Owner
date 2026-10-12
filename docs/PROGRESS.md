# Progress

**Next step:** M3 PR is open. Wait for green CI, squash-merge with `gh pr merge <n> --squash` (no `--delete-branch`; delete branches by hand), then start M4 (auth with OTP mock, app lock, secure storage, router shell with 4 tabs, deep links) on branch `m04-auth-shell`.

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
| M3 | PR open | `api/openapi.yaml`, freezed models, repository interfaces, mock backend + fixtures (scenarios), locations CSV, drift cache + pending queue, ApiConfig switch, module registry; 110 tests incl. contract validation |
| M4–M13 | Not started | |

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
