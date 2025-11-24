#!/bin/bash

# Bash script to start Supabase locally with Docker

echo "🚀 Starting Supabase Local Development Environment"

# Check if Docker is running
echo ""
echo "📦 Checking Docker..."
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi
echo "✅ Docker is running"

# Navigate to docker directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if .env file exists, if not create from example
if [ ! -f ".env" ]; then
    echo ""
    echo "📝 Creating .env file from .env.example..."
    if [ -f ".env.example" ]; then
        cp ".env.example" ".env"
        echo "✅ Created .env file"
        echo "⚠️  Please review and update the .env file with your own secrets for production use!"
    else
        echo "❌ .env.example not found!"
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi

# Start Docker Compose
echo ""
echo "🐳 Starting Supabase services..."
docker compose up -d

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Supabase is starting up!"
    echo ""
    echo "📍 Access your services:"
    echo "   - Studio:        http://localhost:54323"
    echo "   - API Gateway:   http://localhost:8000"
    echo "   - Database:      localhost:54322"
    echo "   - Inbucket (Mail): http://localhost:9000"
    echo ""
    echo "💡 To view logs: docker compose logs -f"
    echo "💡 To stop: docker compose down"
else
    echo ""
    echo "❌ Failed to start Supabase. Check the logs above for errors."
    exit 1
fi

