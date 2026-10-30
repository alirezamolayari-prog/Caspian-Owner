# M20 – Update notice, «رد کردن», bell entry, install after leaving the page

## Prompt (as written for Claude Code)

> Work in the Caspian Owner repo (Flutter, `alirezamolayari-prog/Caspian-Owner`).
> First read `CLAUDE.md`, `docs/PROGRESS.md` and the project's graphify markdown
> file (if it exists on this machine) to find the update, notification and About code.
> Put any downloads, installs or scratch files in a folder you create on drive **E**
> (drive C is full).
>
> Goal: when the owner opens the app and a newer version exists, a dialog
> introduces it (version, size, what's new) with two buttons:
> - **«به‌روزرسانی»** → opens **«درباره و نسخه»** (About). That page shows the
>   new version and a **«دانلود و نصب»** button. After pressing it the owner may
>   leave the page (or the app); the download keeps going and Android's install
>   prompt appears by itself when it is done (if the app is in the background,
>   a phone notification says the update is ready, and the install prompt opens
>   as soon as the app is back in front).
> - **«رد کردن»** → closes the dialog, the owner keeps working. The update then
>   lives on: a dot on the **bell** (hub + warehouse home), a first row in the
>   **notifications** list («نسخه X آماده است») that opens About, and one phone
>   notification per version (tap → About).
>
> Rules: follow CLAUDE.md (ARB strings only, theme tokens only, RTL, Persian
> digits, 48dp targets, semantic labels, « – » separator, no new packages).
> The dialog is shown again on every app start while the update is pending
> (check on every launch, not once a day). The blocking «update required» flow
> must keep working. The bell list must show the update entry even while the
> server has no notification API («به‌زودی»). Add/adjust widget tests, keep the
> accessibility test green. Branch `m20-update-notice`, small English commits,
> open a PR, wait for CI and **merge it yourself (squash) once CI is green**.
> Update `docs/PROGRESS.md` and `docs/CHANGELOG.md`.

## Plan

1. **UpdateController** (`lib/core/update/update_controller.dart`)
   - Check on every launch (`check()` no longer throttled to once a day; About
     still forces it).
   - New state: `downloading` (progress), `readyApk` (verified file waiting to be
     installed), `notifiedBuild`.
   - `downloadAndInstall()` ignores a second tap while downloading; after the
     download: app in front → open the installer; app in background → keep
     `readyApk`, post «به‌روزرسانی آماده نصب است» (tap → About).
   - `setForeground(bool)` from `app.dart`'s lifecycle: on return to the app it
     opens a waiting installer, and continues after the «install unknown apps»
     permission was granted.
   - After the installer was opened the button becomes «نصب» again (it used to
     stay disabled if the owner cancelled Android's prompt).
   - `dismiss()` («رد کردن»): no dialog again this run, one phone notification
     per version.
2. **Dialog** (`UpdateOfferHost`): version, size, changelog; «رد کردن» /
   «به‌روزرسانی» → `push(Routes.about)`. «رد کردن» shows a SnackBar pointing at
   the bell.
3. **UpdatePanel** (new, `lib/core/update/update_panel.dart`): the shared body
   (version, size, changes, permission help, errors, progress, «دانلود و نصب» /
   «نصب»), plus «می‌توانید از این صفحه خارج شوید…» while downloading. Used by
   About (non-blocking) and by the blocking `UpdateScreen`.
   `Routes.update` now redirects to About.
4. **About**: shows the panel whenever an update is known; otherwise the
   existing «بررسی به‌روزرسانی» button. Back from About opened by a
   notification goes to the hub.
5. **Bell**: `UpdateBellIcon` (Badge dot + semantic label) on hub and warehouse
   home; `NotificationsScreen` always shows an «نسخه تازه» row first (opens
   About), even when the list itself is «به‌زودی».
6. **Phone notifications**: `LocalNotifications.showUpdate()` on a new
   «به‌روزرسانی» channel, payload `/about`.
7. Tests: dialog → About, «رد کردن» → bell dot + list row → About, panel
   download states with a fake installer/downloader; accessibility test for
   About with an update.
