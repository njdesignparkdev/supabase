# PowerShell script to start Supabase locally with Docker

Write-Host "🚀 Starting Supabase Local Development Environment" -ForegroundColor Cyan

# Check if Docker is running
Write-Host "`n📦 Checking Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Navigate to docker directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Check if .env file exists, if not create from example
if (-not (Test-Path ".env")) {
    Write-Host "`n📝 Creating .env file from .env.example..." -ForegroundColor Yellow
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "✅ Created .env file" -ForegroundColor Green
        Write-Host "⚠️  Please review and update the .env file with your own secrets for production use!" -ForegroundColor Yellow
    } else {
        Write-Host "❌ .env.example not found!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Start Docker Compose
Write-Host "`n🐳 Starting Supabase services..." -ForegroundColor Yellow
docker compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Supabase is starting up!" -ForegroundColor Green
    Write-Host "`n📍 Access your services:" -ForegroundColor Cyan
    Write-Host "   - Studio:        http://localhost:54323" -ForegroundColor White
    Write-Host "   - API Gateway:   http://localhost:8000" -ForegroundColor White
    Write-Host "   - Database:      localhost:54322" -ForegroundColor White
    Write-Host "   - Inbucket (Mail): http://localhost:9000" -ForegroundColor White
    Write-Host "`n💡 To view logs: docker compose logs -f" -ForegroundColor Yellow
    Write-Host "💡 To stop: docker compose down" -ForegroundColor Yellow
} else {
    Write-Host "`n❌ Failed to start Supabase. Check the logs above for errors." -ForegroundColor Red
    exit 1
}

