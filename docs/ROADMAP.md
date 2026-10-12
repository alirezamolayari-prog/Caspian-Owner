# Roadmap

| # | Milestone | Done when |
|---|---|---|
| M0 | Environment + human steps | `flutter doctor` OK for Android; gh authenticated; checklist answered |
| M1 | Scaffold: project, lints, CI, LICENSE, CLAUDE.md, docs skeleton, .gitignore, signing config | CI green on the first PR |
| M2 | Brand, light/dark theme from the UI tokens, Vazirmatn bundled, RTL, fa locale, ARB, Jalali + Persian digits | Golden test of a sample screen |
| M3 | `api/openapi.yaml`, models, repository interfaces, mock repositories + fixtures (incl. locations CSV), drift cache, pending queue | Unit tests for mocks and the queue |
| M4 | Auth (OTP mock), app lock, secure storage, router shell with 4 tabs + deep links | Login → Home works |
| M5 | Home | Matches the UI spec; empty/loading/error states |
| M6 | Requests list + detail + approve/reject (fingerprint, undo, offline queue, 409) + chat + location usage history | Widget + integration tests |
| M7 | Stock + item movements sheet | Tests |
| M8 | Surprise count flow + results + count history | Tests |
| M9 | Assistant (mock) with history and suggestion chips | Tests |
| M10 | More: reports, purchase-list placeholder, users & access, settings, About + developer screen | Tests |
| M11 | Notifications (workmanager poll → local notifications → deep link) | Manual test on a phone if available |
| M12 | Update system + version tooling + release workflow + RELEASING.md | Unit tests; dry-run manifest |
| M13 | Final QA, accessibility, performance, user guide, changelog, v0.1.0 | Release published, or ready to publish |

## Later (not in this build)
- Real middle server (Iranian VPS, FastAPI + PostgreSQL/MariaDB) and the Warehouse outbox sync.
- Real SMS OTP, real AI assistant, a push channel (UnifiedPush or ntfy) instead of polling.
- Purchasing (لیست خرید), and other Caspian modules (parking, services, CRM).
