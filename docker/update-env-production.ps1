# PowerShell script to update .env file with production-ready secure passwords

Write-Host "Updating .env file with production-ready secure passwords..." -ForegroundColor Cyan

$rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider

function Get-RandomString {
    param($length)
    $chars = (65..90) + (97..122) + (48..57)
    -join ($chars | Get-Random -Count $length | ForEach-Object {[char]$_})
}

function Get-RandomBase64 {
    param($length)
    $bytes = New-Object byte[] $length
    $rng.GetBytes($bytes)
    [Convert]::ToBase64String($bytes)
}

# Generate secure values
$pgPass = Get-RandomString 48
$jwtSec = Get-RandomString 64
$dashPass = Get-RandomString 32
$secKey = Get-RandomBase64 64
$vaultKey = Get-RandomString 32
$pgMetaKey = Get-RandomString 32
$logPub = Get-RandomString 48
$logPriv = Get-RandomString 48
$poolTenant = Get-RandomString 24

Write-Host "Generated secure passwords and keys" -ForegroundColor Green

# Read current .env file
$envPath = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envPath)) {
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item (Join-Path $PSScriptRoot ".env.example") $envPath
}

$content = Get-Content $envPath -Raw

# Replace values
$content = $content -replace 'POSTGRES_PASSWORD=.*', "POSTGRES_PASSWORD=$pgPass"
$content = $content -replace 'JWT_SECRET=.*', "JWT_SECRET=$jwtSec"
$content = $content -replace 'DASHBOARD_USERNAME=.*', "DASHBOARD_USERNAME=admin"
$content = $content -replace 'DASHBOARD_PASSWORD=.*', "DASHBOARD_PASSWORD=$dashPass"
$content = $content -replace 'SECRET_KEY_BASE=.*', "SECRET_KEY_BASE=$secKey"
$content = $content -replace 'VAULT_ENC_KEY=.*', "VAULT_ENC_KEY=$vaultKey"
$content = $content -replace 'PG_META_CRYPTO_KEY=.*', "PG_META_CRYPTO_KEY=$pgMetaKey"
$content = $content -replace 'POOLER_TENANT_ID=.*', "POOLER_TENANT_ID=$poolTenant"
$content = $content -replace 'LOGFLARE_PUBLIC_ACCESS_TOKEN=.*', "LOGFLARE_PUBLIC_ACCESS_TOKEN=$logPub"
$content = $content -replace 'LOGFLARE_PRIVATE_ACCESS_TOKEN=.*', "LOGFLARE_PRIVATE_ACCESS_TOKEN=$logPriv"

# Save updated content
$content | Set-Content $envPath -NoNewline

Write-Host ""
Write-Host "Production .env file updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Generated secure values:" -ForegroundColor Cyan
Write-Host "  POSTGRES_PASSWORD: $pgPass" -ForegroundColor Gray
Write-Host "  JWT_SECRET: $jwtSec" -ForegroundColor Gray
Write-Host "  DASHBOARD_PASSWORD: $dashPass" -ForegroundColor Gray
Write-Host ""
Write-Host "IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Generate ANON_KEY and SERVICE_ROLE_KEY using your JWT_SECRET" -ForegroundColor White
Write-Host "   Visit: https://supabase.com/docs/guides/self-hosting/docker" -ForegroundColor Gray
Write-Host "2. Update SITE_URL and SUPABASE_PUBLIC_URL with your production domain" -ForegroundColor White
Write-Host "3. Configure SMTP settings for email authentication" -ForegroundColor White
Write-Host "4. Review all settings before deploying to production" -ForegroundColor White

