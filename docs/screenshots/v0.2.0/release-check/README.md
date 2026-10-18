# Release check, v0.2.0 (build 3)

The release APK is universal, signed with the release key and built with R8. Each emulator was tested on a fresh install, one at a time, with the emulator language set to English, no screen lock and no fingerprint. The PC has 8 GB RAM; emulators ran with `-memory 1536`.

| Emulator | Result |
|---|---|
| API 24 (Android 7), 1080×2340 | **Not done – limited RAM.** The emulator crashed while booting (software OpenGL `opengl32sw` missing) and was not retried. |
| API 29 (Android 10), small screen 480×800 | **Not done – limited RAM.** It booted, but Android's own services stopped responding ("Can't find service: package"), so the APK could not be installed. |
| API 35 (Android 15), dark mode | **OK.** See the details below. |

Details for API 35:
- Cold start: 7.6 s on an overloaded emulator.
- Persian and RTL shown even though the emulator was in English.
- Login with 11111 works.
- With no lock or fingerprint, the app asks to create an app PIN instead of crashing (`api35_dark_3_pin_setup.png`).
- The hub shows the sample data («۴ منتظر»), and the warehouse opens.
- Chat on request 121: my messages on the right, the others' on the left. Older pages load and «جدیدترین» works.
- No crash entries in logcat.

**One ANR during login** came from the overload, not from an app fault:
- At the time, the emulator's load average was 17, and the keyboard, messaging, search and safety apps were also not responding.
- The app's ANR reason was "No response to onStartJob" (the WorkManager notification poll).

**Also checked on the build itself:**
- `aapt`: minSdk 24, targetSdk 36, native code arm64-v8a / armeabi-v7a / x86_64, versionCode 3.
- `apksigner`: certificate SHA-256 `f332c7e7…c468ec`, the release key.

The same release builds (R8 on) also ran on Alireza's Redmi Note 13 (Android 15) through v0.2.0 build 2: fingerprint, secure storage and the JSON models all worked. No ProGuard keep rules were needed.
