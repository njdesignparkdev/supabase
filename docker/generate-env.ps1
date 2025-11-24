# PowerShell script to generate production-ready .env file with strong passwords

Write-Host "🔐 Generating production-ready .env file..." -ForegroundColor Cyan

function Generate-SecureString {
    param([int]$Length = 64)
    $chars = (48..57) + (65..90) + (97..122) + (33..47) + (58..64) + (91..96) + (123..126)
    -join ($chars | Get-Random -Count $Length | ForEach-Object {[char]$_})
}

function Generate-Base64 {
    param([int]$Length = 64)
    $bytes = New-Object byte[] $Length
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
    [Convert]::ToBase64String($bytes)
}

# Generate all secure values
Write-Host "`n📝 Generating secure passwords and keys..." -ForegroundColor Yellow

$postgresPassword = Generate-SecureString -Length 48
$jwtSecret = Generate-SecureString -Length 64
$dashboardPassword = Generate-SecureString -Length 32
$secretKeyBase = Generate-Base64 -Length 64
$vaultEncKey = Generate-SecureString -Length 32
$pgMetaCryptoKey = Generate-SecureString -Length 32
$logflarePublic = Generate-SecureString -Length 48
$logflarePrivate = Generate-SecureString -Length 48
$poolerTenantId = Generate-SecureString -Length 24

Write-Host "✅ Generated all secure values" -ForegroundColor Green

# Note: ANON_KEY and SERVICE_ROLE_KEY need to be generated using JWT_SECRET
# These are JWTs that need to be signed. For now, we'll use placeholders
# and provide instructions to generate them using Supabase CLI or online tool

$envContent = @"
############
# Secrets - PRODUCTION READY
# Generated on: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# ⚠️  KEEP THIS FILE SECURE - DO NOT COMMIT TO VERSION CONTROL
############

POSTGRES_PASSWORD=$postgresPassword
JWT_SECRET=$jwtSecret
DASHBOARD_USERNAME=admin
DASHBOARD_PASSWORD=$dashboardPassword
SECRET_KEY_BASE=$secretKeyBase
VAULT_ENC_KEY=$vaultEncKey
PG_META_CRYPTO_KEY=$pgMetaCryptoKey

############
# API Keys - JWT Tokens
# ⚠️  IMPORTANT: Generate these using your JWT_SECRET
# Use: supabase gen bearer-jwt --role anon (for ANON_KEY)
# Use: supabase gen bearer-jwt --role service_role (for SERVICE_ROLE_KEY)
# Or use the JWT generator at: https://supabase.com/docs/guides/self-hosting/docker#generate-api-keys
############

# TODO: Generate these using JWT_SECRET above
# ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
# SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Temporary demo keys (REPLACE BEFORE PRODUCTION):
ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJzZXJ2aWNlX3JvbGUiLAogICAgImlzcyI6ICJzdXBhYmFzZS1kZW1vIiwKICAgICJpYXQiOiAxNjQxNzY5MjAwLAogICAgImV4cCI6IDE3OTk1MzU2MDAKfQ.DaYlNEoUrrEn2Ig7tqibS-PHK5vgusbcbo7X36XVt4Q


############
# Database - You can change these to any PostgreSQL database that has logical replication enabled.
############

POSTGRES_HOST=db
POSTGRES_DB=postgres
POSTGRES_PORT=5432
# default user is postgres


############
# Supavisor -- Database pooler
############
# Port Supavisor listens on for transaction pooling connections
POOLER_PROXY_PORT_TRANSACTION=6543
# Maximum number of PostgreSQL connections Supavisor opens per pool
POOLER_DEFAULT_POOL_SIZE=20
# Maximum number of client connections Supavisor accepts per pool
POOLER_MAX_CLIENT_CONN=100
# Unique tenant identifier
POOLER_TENANT_ID=$poolerTenantId
# Pool size for internal metadata storage used by Supavisor
# This is separate from client connections and used only by Supavisor itself
POOLER_DB_POOL_SIZE=5


############
# API Proxy - Configuration for the Kong Reverse proxy.
############

KONG_HTTP_PORT=8000
KONG_HTTPS_PORT=8443


############
# API - Configuration for PostgREST.
############

PGRST_DB_SCHEMAS=public,storage,graphql_public


############
# Auth - Configuration for the GoTrue authentication server.
############

## General
SITE_URL=http://localhost:3000
ADDITIONAL_REDIRECT_URLS=
JWT_EXPIRY=3600
DISABLE_SIGNUP=false
API_EXTERNAL_URL=http://localhost:8000

## Mailer Config
MAILER_URLPATHS_CONFIRMATION="/auth/v1/verify"
MAILER_URLPATHS_INVITE="/auth/v1/verify"
MAILER_URLPATHS_RECOVERY="/auth/v1/verify"
MAILER_URLPATHS_EMAIL_CHANGE="/auth/v1/verify"

## Email auth
ENABLE_EMAIL_SIGNUP=true
ENABLE_EMAIL_AUTOCONFIRM=false
SMTP_ADMIN_EMAIL=admin@example.com
SMTP_HOST=supabase-mail
SMTP_PORT=2500
SMTP_USER=fake_mail_user
SMTP_PASS=fake_mail_password
SMTP_SENDER_NAME=fake_sender
ENABLE_ANONYMOUS_USERS=false

## Phone auth
ENABLE_PHONE_SIGNUP=true
ENABLE_PHONE_AUTOCONFIRM=true


############
# Studio - Configuration for the Dashboard
############

STUDIO_DEFAULT_ORGANIZATION=Default Organization
STUDIO_DEFAULT_PROJECT=Default Project

# replace if you intend to use Studio outside of localhost
SUPABASE_PUBLIC_URL=http://localhost:8000

# Enable webp support
IMGPROXY_ENABLE_WEBP_DETECTION=true

# Add your OpenAI API key to enable SQL Editor Assistant
OPENAI_API_KEY=


############
# Functions - Configuration for Functions
############
# NOTE: VERIFY_JWT applies to all functions. Per-function VERIFY_JWT is not supported yet.
FUNCTIONS_VERIFY_JWT=false


############
# Logs - Configuration for Analytics
# Please refer to https://supabase.com/docs/reference/self-hosting-analytics/introduction
############

# Change vector.toml sinks to reflect this change
# these cannot be the same value
LOGFLARE_PUBLIC_ACCESS_TOKEN=$logflarePublic
LOGFLARE_PRIVATE_ACCESS_TOKEN=$logflarePrivate

# Docker socket location - this value will differ depending on your OS
DOCKER_SOCKET_LOCATION=/var/run/docker.sock

# Google Cloud Project details
GOOGLE_PROJECT_ID=GOOGLE_PROJECT_ID
GOOGLE_PROJECT_NUMBER=GOOGLE_PROJECT_NUMBER
"@

# Save to .env file
$envPath = Join-Path $PSScriptRoot ".env"
$envContent | Out-File -FilePath $envPath -Encoding utf8 -NoNewline

Write-Host "`n✅ Production .env file created at: $envPath" -ForegroundColor Green
Write-Host "`n⚠️  IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Generate ANON_KEY and SERVICE_ROLE_KEY using your JWT_SECRET" -ForegroundColor White
Write-Host "2. Update SITE_URL and SUPABASE_PUBLIC_URL with your production domain" -ForegroundColor White
Write-Host "3. Configure SMTP settings for email authentication" -ForegroundColor White
Write-Host "4. Review all settings before deploying to production" -ForegroundColor White
Write-Host "`n📋 Generated Secrets Summary:" -ForegroundColor Cyan
Write-Host "   POSTGRES_PASSWORD: $postgresPassword" -ForegroundColor Gray
Write-Host "   JWT_SECRET: $jwtSecret" -ForegroundColor Gray
Write-Host "   DASHBOARD_PASSWORD: $dashboardPassword" -ForegroundColor Gray
Write-Host ""
Write-Host "To generate JWT keys, visit:" -ForegroundColor Yellow
Write-Host "   https://supabase.com/docs/guides/self-hosting/docker" -ForegroundColor White
Write-Host "   See section on generating API keys" -ForegroundColor Gray

