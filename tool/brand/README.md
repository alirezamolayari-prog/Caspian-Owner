# Launcher icon

> **Not applied.** Since v0.2.0 the app ships the default Flutter icon again, at Alireza's request, until a proper icon is designed. Running the two commands below would bring the «ک» icon back.

The icon is the letter `Brand.iconGlyph` (Vazirmatn Bold) on the brand primary color (`LightTokens.primary`). To rebrand, change `lib/core/brand/brand.dart` (and the colors in `lib/core/theme/tokens.dart`), then regenerate:

```powershell
flutter test tool/brand/render_launcher_icon_test.dart   # draws tool/brand/out/*.png
dart run flutter_launcher_icons                         # writes android/app/src/main/res/mipmap-*
```

`out/` holds the 1024 px sources (adaptive foreground and background, and the legacy rounded square for Android 7). They are committed, so the icon can be regenerated without re-drawing it.
