# Progress

**Next step:** M1 PR is open. Wait for green CI, squash-merge, then start M2 (brand, theme, Vazirmatn, RTL, ARB, Jalali) on branch `m02-brand-theme`.

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

## Milestones
| # | Status | Notes |
|---|---|---|
| M0 | Done | `flutter doctor` green (Flutter + Android, licenses accepted); no phone connected |
| M1 | In progress | 5 local commits on `m01-scaffold`; format/analyze/test green locally |
| M2â€“M13 | Not started | Vazirmatn v33.003 zip already in `E:\dev\_downloads\vazirmatn` |

## Human checklist status (آ§2.4)
- [x] H1 UAC prompts (JDK 17, KeePassXC)
- [x] H2 removed `C:\src\flutter\bin` from the System PATH
- [x] H3 licenses: the new `android sdk` CLI shows the terms without a prompt; `--licenses` is no longer used
- [x] H4 release keystore `E:\keys\caspian-owner-release.jks` (alias `caspian-owner`), in KeePassXC + backups
- [x] H5 `android/key.properties` (git-ignored)
- [x] H6 GitHub secrets KEYSTORE_BASE64, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD
- [ ] H7 (optional) phone connected

## Open problems / notes
- Harmless build warning: the new `android sdk` CLI writes package.xml v4, AGP reads up to v3 ("SDK processing ... XML version 4"). Builds succeed.
- Kotlin daemon can't start on this PC; `kotlin.compiler.execution.strategy=in-process` in `android/gradle.properties`. Gradle heap lowered to 3G (PC has 8 GB RAM).
- Release APK signing verified: cert SHA-256 `f332c7e7…c468ec` (full value in docs/RELEASING.md).
