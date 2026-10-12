# Progress

**Next step:** Wait for Alireza to finish the M0 checklist (H2–H7). Then install the SDK packages (`sdkmanager "platform-tools" "platforms;android-36" "platforms;android-37.0" "build-tools;36.1.0"`), check that `flutter doctor -v` is green, run `adb devices`, and continue M1 on branch `m01-scaffold`.

## Environment (M0)
| Item | Value |
|---|---|
| Flutter | 3.47.7 stable (Dart 3.13.5) at `E:\dev\flutter` |
| JDK | Microsoft OpenJDK 17.0.20 at `C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot` (`flutter config --jdk-dir`) |
| Android SDK | `E:\dev\android-sdk` (cmdline-tools 23 at `cmdline-tools\latest`) |
| Caches | `PUB_CACHE=E:\dev\.pub-cache`, `GRADLE_USER_HOME=E:\dev\.gradle` |
| KeePassXC | 2.7.12 |
| Old, untouched | `C:\src\flutter` (3.44.6, still in System PATH until H2), old SDK in `%LOCALAPPDATA%\Android\Sdk`, Android Studio |

Shells started before M0 don't see the new user env vars. Set them inline, or open a new terminal.

## Milestones
| # | Status | Notes |
|---|---|---|
| M0 | In progress | Tools installed; waiting for human checklist |
| M1 | Started | git attached to `origin/main`; `flutter create` done; applicationId `com.alirezamolayari.caspianowner`; signing config + `key.properties.example`; `.gitignore` secrets. Not yet committed |
| M2–M13 | Not started | |

## Human checklist status (§2.4)
- [x] H1 UAC prompts (JDK 17, KeePassXC)
- [ ] H2 remove `C:\src\flutter\bin` from System PATH
- [ ] H3 accept Android licenses
- [ ] H4 release keystore + KeePassXC + 3 backups
- [ ] H5 `android/key.properties`
- [ ] H6 GitHub Actions secrets
- [ ] H7 (optional) phone connected

## Open problems
None.
