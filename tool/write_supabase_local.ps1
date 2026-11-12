# Write .vscode/supabase.local.json from URL + anon key (never commit the output).
param(
  [Parameter(Mandatory = $true)][string]$Url,
  [Parameter(Mandatory = $true)][string]$AnonKey,
  [ValidateSet('auto', 'mock', 'supabase')][string]$BackendMode = 'auto'
)

$ErrorActionPreference = 'Stop'
$appRoot = Split-Path -Parent $PSScriptRoot
$vscodeDir = Join-Path $appRoot '.vscode'
$outFile = Join-Path $vscodeDir 'supabase.local.json'

New-Item -ItemType Directory -Force -Path $vscodeDir | Out-Null

$payload = [ordered]@{
  SUPABASE_URL      = $Url.Trim().TrimEnd('/')
  SUPABASE_ANON_KEY = $AnonKey.Trim()
  BACKEND_MODE      = $BackendMode
}

$payload | ConvertTo-Json | Set-Content -Path $outFile -Encoding UTF8
Write-Host "Wrote $outFile"
Write-Host "Next: run tool/supabase_live_smoke.ps1"
