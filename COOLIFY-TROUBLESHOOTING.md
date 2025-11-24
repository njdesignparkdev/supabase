# Coolify Troubleshooting Guide

## The Three Files Explained

1. **`docker-compose.yml`** - Main file (use this)
2. **`docker-compose.yaml`** - Copy I created (same content, different extension)
3. **`docker-compose.s3.yml`** - Optional S3 storage (ignore for now)

## Why It Works Locally But Not in Coolify

### ✅ What's Working
- All volume files are in Git ✓
- Docker Compose file is correct ✓
- Services are properly configured ✓

### ❌ Common Issues in Coolify

#### 1. **Volume Path Resolution**
**Problem**: `./volumes/...` paths might not resolve correctly in Coolify

**Solution**: In Coolify, make sure:
- **Base Directory** is set to `/docker`
- Volume paths should work because they're relative to the compose file location

#### 2. **Environment Variables Missing**
**Problem**: Services fail if environment variables aren't set

**Check in Coolify**:
- Go to your application → Environment Variables
- Add ALL variables from `docker/.env.example`
- Critical ones:
  - `POSTGRES_PASSWORD`
  - `JWT_SECRET`
  - `ANON_KEY`
  - `SERVICE_ROLE_KEY`
  - `DASHBOARD_USERNAME`
  - `DASHBOARD_PASSWORD`
  - `SECRET_KEY_BASE`
  - `VAULT_ENC_KEY`
  - `PG_META_CRYPTO_KEY`
  - `LOGFLARE_PUBLIC_ACCESS_TOKEN`
  - `LOGFLARE_PRIVATE_ACCESS_TOKEN`
  - `POOLER_TENANT_ID`
  - And all others from `.env.example`

#### 3. **Docker Socket Access (Vector Service)**
**Problem**: The `vector` service needs Docker socket access:
```yaml
- ${DOCKER_SOCKET_LOCATION}:/var/run/docker.sock:ro,z
```

**Solution**: 
- Set `DOCKER_SOCKET_LOCATION=/var/run/docker.sock` in Coolify environment
- Or Coolify might need special permissions for this

#### 4. **Port Conflicts**
**Problem**: Ports might be in use or not exposed

**Check in Coolify**:
- Port 8000 (Kong/API Gateway)
- Port 54323 (Studio)
- Port 9000 (Analytics/Inbucket)
- Port 54322 (Database - optional)

#### 5. **Build Context**
**Problem**: Coolify might not be using the right directory

**Solution**: 
- **Base Directory**: `/docker`
- **Docker Compose File**: `docker-compose.yml` (or `docker-compose.yaml`)

## Step-by-Step Coolify Configuration

### 1. Repository Settings
- **Repository**: `njdesignparkdev/supabase`
- **Branch**: `main`
- **Build Pack**: `Docker Compose` (or `None`)

### 2. Build Configuration
- **Base Directory**: `/docker`
- **Docker Compose File**: `docker-compose.yml`

### 3. Environment Variables
Copy ALL from your local `docker/.env` file into Coolify's environment section.

### 4. Ports
Expose:
- 8000 (API Gateway)
- 54323 (Studio)
- 9000 (Analytics)

### 5. Check Logs
After deployment, check Coolify logs for specific errors:
- Which service failed?
- What's the error message?
- Are volumes mounting correctly?

## Common Error Messages

### "Volume not found"
- Check that volume files exist in Git
- Verify Base Directory is `/docker`

### "Environment variable not set"
- Add missing variable in Coolify environment section

### "Service failed to start"
- Check service-specific logs
- Verify dependencies (db, analytics) are healthy

### "Permission denied"
- Check Docker socket access for vector service
- Verify volume permissions

## Quick Checklist

- [ ] Base Directory set to `/docker`
- [ ] Docker Compose file: `docker-compose.yml`
- [ ] All environment variables added
- [ ] Ports 8000, 54323, 9000 exposed
- [ ] Build Pack: Docker Compose (not Nixpacks/Deno)
- [ ] Branch: `main`
- [ ] Check deployment logs for specific errors

## Next Steps

1. **Check Coolify deployment logs** - What's the exact error?
2. **Verify environment variables** - Are they all set?
3. **Check service health** - Which service is failing?
4. **Review volume mounts** - Are they accessible?

Share the specific error from Coolify logs and I can help fix it!

