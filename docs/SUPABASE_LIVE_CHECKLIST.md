# BiteBox · Supabase live checklist

Public-safe steps for wiring your own project. Replace placeholders with values from the Supabase dashboard. **Never commit** URL/keys into git.

## Status template

| Step | Status |
| :--- | :--- |
| A Create project | ☐ Ready · `https://<your-ref>.supabase.co` · region of your choice |
| B Run SQL migration | ☐ Success (`menu_items` / `orders` / `order_items` + seed) |
| C Confirm email OFF | ☐ (local demos) |
| D Write `supabase.local.json` | ☐ (gitignored; prefer legacy anon JWT for REST smoke) |
| E `supabase_live_smoke.ps1` | ☐ LIVE SMOKE PASSED |
| F Flutter UI hand-test | ☐ |

## Run the app (hand-test)

From the Flutter app root:

```bash
flutter run --dart-define-from-file=.vscode/supabase.local.json
```

Acceptance: sign up / sign in → menu shows seeded dishes → place order → Orders lists it → another account cannot see that order.

## Re-run smoke

```bash
.\tool\supabase_live_smoke.ps1
```

## Notes

- Keep secrets local only: `.vscode/supabase.local.json`, `.vscode/supabase.secrets.local.md`
- Dashboard may also show `sb_publishable_…`; REST smoke scripts expect the **legacy anon JWT**
- Database password is for direct DB access only — never pass it into Flutter
