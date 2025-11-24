# Deploying Supabase to Coolify

This guide explains how to deploy Supabase to Coolify using Docker Compose.

## Configuration Steps in Coolify

1. **Create a New Resource**:
   - In Coolify, go to your project
   - Click "Add Resource" → "Docker Compose"

2. **Set Build Context**:
   - **Build Context**: `/docker` (or the path to the docker directory)
   - **Docker Compose File**: `docker-compose.yml`
   - **Docker Compose File Location**: Should be in the `docker/` directory

3. **Environment Variables**:
   - Coolify will read from `docker/.env` file
   - Make sure to add all required environment variables in Coolify's environment section
   - **Important**: Never commit `.env` files to Git!

4. **Ports**:
   - **Studio**: 54323
   - **API Gateway**: 8000
   - **Database**: 54322 (internal)
   - **Inbucket (Email)**: 9000

5. **Volumes**:
   - Database data: `./volumes/db/data`
   - Storage: `./volumes/storage`
   - These will be persisted by Coolify

## Required Environment Variables

Make sure to set these in Coolify's environment variables section:

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

And all other variables from `docker/.env.example`

## Troubleshooting

### If Coolify tries to build as Deno/Node app:
- Make sure the build context is set to `/docker`
- Ensure `.nixpacksignore` is in the root directory
- Select "Docker Compose" as the resource type, not "Application"

### If services fail to start:
- Check that all environment variables are set
- Verify Docker Compose file is correct
- Check Coolify logs for specific service errors

