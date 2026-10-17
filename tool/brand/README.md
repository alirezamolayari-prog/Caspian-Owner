# Launcher icon

The icon is the letter `Brand.iconGlyph` (Vazirmatn Bold) on the brand primary color (`LightTokens.primary`). To rebrand, change `lib/core/brand/brand.dart` (and the colors in `lib/core/theme/tokens.dart`), then regenerate:

```powershell
flutter test tool/brand/render_launcher_icon_test.dart   # draws tool/brand/out/*.png
dart run flutter_launcher_icons                         # writes android/app/src/main/res/mipmap-*
```

`out/` holds the 1024 px sources (adaptive foreground and background, and the legacy rounded square for Android 7). They are committed, so the icon can be regenerated without re-drawing it.
