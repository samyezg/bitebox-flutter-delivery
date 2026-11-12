# BiteBox Supabase

Step-by-step live checklist: [`../docs/SUPABASE_LIVE_CHECKLIST.md`](../docs/SUPABASE_LIVE_CHECKLIST.md)

## 1. Create a project

1. Open [Supabase](https://supabase.com/) and create a project.
2. Auth → Providers: enable Email.
3. For local demos, disable **Confirm email**.

## 2. Apply schema

In SQL Editor, run:

`migrations/20261110190000_bitebox_menu_and_orders.sql`

## 3. Local Flutter config

From the Flutter app root:

```bash
# PowerShell helpers (Windows)
.\tool\write_supabase_local.ps1 -Url "https://<your-ref>.supabase.co" -AnonKey "eyJ..."
.\tool\supabase_live_smoke.ps1
```

**Do not commit** `.vscode/supabase.local.json`.

```bash
flutter run --dart-define-from-file=.vscode/supabase.local.json
```

Or use offline Fake/Mock repositories:

```bash
flutter run --dart-define=BACKEND_MODE=mock
```
