# Why It Works Locally But Not in Coolify

## The Three Docker Compose Files Explained

### 1. `docker-compose.yml` (Main File)
- **Purpose**: Main Supabase configuration with all services
- **Used**: Locally with `docker compose up`
- **Contains**: All 12+ services (studio, kong, auth, db, etc.)

### 2. `docker-compose.yaml` (Copy for Coolify)
- **Purpose**: Same as `.yml` but with `.yaml` extension
- **Created**: For Coolify compatibility (some systems prefer `.yaml`)
- **Content**: Identical to `docker-compose.yml`

### 3. `docker-compose.s3.yml` (Optional S3 Storage)
- **Purpose**: Alternative storage backend using MinIO (S3-compatible)
- **Used**: Only if you want S3 storage instead of file storage
- **Command**: `docker compose -f docker-compose.yml -f docker-compose.s3.yml up`
- **Not needed**: For basic deployment

## Why It Works Locally But Not in Coolify

### Issue 1: Volume Paths
**Local**: `./volumes/db/data` resolves to `C:\RahulKumar\supabase-fresh\docker\volumes\db\data`
**Coolify**: `./volumes/...` might not resolve correctly because:
- Build context is `/docker`
- Relative paths might be relative to a different directory
- Coolify might need absolute paths or named volumes

### Issue 2: Missing Volume Files
The compose file references files that must exist:
- `./volumes/db/realtime.sql`
- `./volumes/db/webhooks.sql`
- `./volumes/db/roles.sql`
- `./volumes/db/jwt.sql`
- `./volumes/db/_supabase.sql`
- `./volumes/db/logs.sql`
- `./volumes/db/pooler.sql`
- `./volumes/api/kong.yml`
- `./volumes/logs/vector.yml`
- `./volumes/pooler/pooler.exs`

**If these don't exist in Git**, Coolify can't find them!

### Issue 3: Environment Variables
**Local**: Reads from `docker/.env` file
**Coolify**: Needs all variables set in Coolify's environment section
- Missing variables = services fail to start

### Issue 4: Docker Socket Access
The `vector` service needs Docker socket access:
```yaml
- ${DOCKER_SOCKET_LOCATION}:/var/run/docker.sock:ro,z
```
**Coolify might restrict this** for security reasons.

## Solutions

### Solution 1: Check Volume Files Exist in Git
Run this to verify:
```bash
cd docker
ls -la volumes/db/*.sql
ls -la volumes/api/kong.yml
ls -la volumes/logs/vector.yml
ls -la volumes/pooler/pooler.exs
```

### Solution 2: Use Named Volumes for Coolify
Instead of `./volumes/...`, use named volumes that Coolify can manage.

### Solution 3: Set All Environment Variables
Make sure ALL variables from `docker/.env.example` are set in Coolify.

### Solution 4: Check Coolify Logs
The specific error in Coolify logs will tell you what's missing.

