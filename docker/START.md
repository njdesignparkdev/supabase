# Starting Supabase Locally with Docker

This guide will help you start Supabase on your local machine using Docker.

## Prerequisites

1. **Docker Desktop** must be installed and running
   - Download from: https://www.docker.com/products/docker-desktop
   - Make sure Docker Desktop is running before proceeding

2. **Docker Compose** (usually included with Docker Desktop)

## Quick Start

### Windows (PowerShell)

```powershell
cd docker
.\start-supabase.ps1
```

### Linux/Mac (Bash)

```bash
cd docker
chmod +x start-supabase.sh
./start-supabase.sh
```

### Manual Start

If you prefer to start manually:

```bash
cd docker

# Create .env file if it doesn't exist
if not exist .env copy .env.example .env

# Start services
docker compose up -d
```

## Accessing Services

Once started, you can access:

- **Studio Dashboard**: http://localhost:54323
- **API Gateway**: http://localhost:8000
- **Database**: `localhost:54322`
- **Inbucket (Email Testing)**: http://localhost:9000

## Environment Variables

The `.env` file contains all configuration. Key variables:

- `POSTGRES_PASSWORD`: Database password
- `JWT_SECRET`: JWT signing secret (must be at least 32 characters)
- `ANON_KEY`: Public anonymous key
- `SERVICE_ROLE_KEY`: Service role key (has admin privileges)

⚠️ **Important**: The default `.env` file uses demo keys. For production, generate new secrets!

## Useful Commands

### View Logs
```bash
docker compose logs -f
```

### View Logs for Specific Service
```bash
docker compose logs -f studio
docker compose logs -f db
docker compose logs -f auth
```

### Stop Services
```bash
docker compose down
```

### Stop and Remove Volumes (Clean Reset)
```bash
docker compose down -v
```

### Restart Services
```bash
docker compose restart
```

### Check Service Status
```bash
docker compose ps
```

## Troubleshooting

### Docker Desktop Not Running
If you see errors about Docker not being available:
1. Start Docker Desktop
2. Wait for it to fully start (whale icon in system tray)
3. Try again

### Port Already in Use
If a port is already in use, you can:
1. Stop the conflicting service
2. Or modify the port in `docker-compose.yml` and `.env`

### Reset Everything
To completely reset Supabase (⚠️ deletes all data):

```bash
cd docker
./reset.sh  # Linux/Mac
# or manually:
docker compose down -v
rm -rf volumes/db/data
```

## Next Steps

1. Access Studio at http://localhost:54323
2. Create your first table
3. Set up authentication
4. Start building your application!

For more information, see the [Supabase Documentation](https://supabase.com/docs).

