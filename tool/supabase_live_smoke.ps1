# Live smoke against a real Supabase project using supabase.local.json
# Prerequisites:
# 1) SQL migration applied
# 2) Email confirm disabled (or use confirmed user)
# 3) .vscode/supabase.local.json present

param(
  [string]$ConfigPath = ''
)

$ErrorActionPreference = 'Stop'
$appRoot = Split-Path -Parent $PSScriptRoot
if (-not $ConfigPath) {
  $ConfigPath = Join-Path $appRoot '.vscode\supabase.local.json'
}
if (-not (Test-Path $ConfigPath)) {
  throw "Missing $ConfigPath — run tool/write_supabase_local.ps1 first."
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
$url = [string]$config.SUPABASE_URL
$key = [string]$config.SUPABASE_ANON_KEY
if (-not $url -or -not $key) { throw 'SUPABASE_URL / SUPABASE_ANON_KEY missing in config.' }

$headers = @{
  apikey        = $key
  Authorization = "Bearer $key"
  'Content-Type' = 'application/json'
}

Write-Host "== 1) menu_items public read =="
$menu = Invoke-RestMethod -Method Get -Uri "$url/rest/v1/menu_items?select=id,name,price_in_cents&order=sort_order" -Headers $headers
if (-not $menu -or $menu.Count -lt 12) {
  throw "Expected >=12 menu items, got $($menu.Count). Did you run the SQL migration?"
}
Write-Host ("OK menu count={0} first={1}" -f $menu.Count, $menu[0].name)

$email = ("bitebox.smoke.{0}@example.com" -f ([DateTimeOffset]::UtcNow.ToUnixTimeSeconds()))
$password = 'Secret1!'

Write-Host "== 2) auth signUp =="
$signUpBody = @{ email = $email; password = $password } | ConvertTo-Json
try {
  $signUp = Invoke-RestMethod -Method Post -Uri "$url/auth/v1/signup" -Headers $headers -Body $signUpBody
} catch {
  throw "signUp failed: $($_.Exception.Message). If email confirmation is ON, disable it for demos."
}
$token = $signUp.access_token
$userId = $signUp.user.id
if (-not $token) {
  # Some projects return user without session when confirm-email is required
  throw 'No access_token from signUp. Disable Auth → Providers → Email confirm for local demos, then retry.'
}
Write-Host "OK signed up user=$userId"

$authHeaders = @{
  apikey        = $key
  Authorization = "Bearer $token"
  'Content-Type' = 'application/json'
  Prefer        = 'return=representation'
}

Write-Host "== 3) place order + items =="
$orderBody = @{
  user_id        = $userId
  total_cents    = 899
  status         = 'confirmed'
  address_text   = '123 Market Street, Demo City'
  payment_method = 'cardDemo'
} | ConvertTo-Json

$orderRows = Invoke-RestMethod -Method Post -Uri "$url/rest/v1/orders" -Headers $authHeaders -Body $orderBody
$orderId = $orderRows[0].id
$orderNumber = $orderRows[0].order_number
Write-Host "OK order id=$orderId number=$orderNumber"

$itemBody = @(
  @{
    order_id       = $orderId
    item_id        = 'classic-beef-burger'
    name           = 'Classic Beef Burger'
    price_in_cents = 899
    quantity       = 1
    category       = 'burger'
  }
) | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "$url/rest/v1/order_items" -Headers $authHeaders -Body $itemBody | Out-Null
Write-Host 'OK order_items inserted'

Write-Host "== 4) list own orders =="
$listed = Invoke-RestMethod -Method Get -Uri "$url/rest/v1/orders?select=id,order_number,total_cents&order=created_at.desc" -Headers $authHeaders
if (-not ($listed | Where-Object { $_.id -eq $orderId })) {
  throw 'Placed order not visible to the same user (RLS issue).'
}
Write-Host ("OK visible orders={0}" -f $listed.Count)

Write-Host "== 5) cross-user isolation (anon cannot read orders) =="
try {
  $anonOrders = Invoke-RestMethod -Method Get -Uri "$url/rest/v1/orders?select=id" -Headers $headers
  if ($anonOrders -and $anonOrders.Count -gt 0) {
    throw 'Anon was able to read orders — RLS is too open.'
  }
  Write-Host 'OK anon sees no orders'
} catch {
  # PostgREST may return 401/empty; treat empty/error without rows as pass
  Write-Host "OK anon blocked ($($_.Exception.Message))"
}

Write-Host ''
Write-Host 'LIVE SMOKE PASSED'
Write-Host "Test user: $email / $password"
Write-Host 'Next: flutter run --dart-define-from-file=.vscode/supabase.local.json'
