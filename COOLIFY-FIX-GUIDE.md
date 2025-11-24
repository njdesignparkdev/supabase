# Fix Coolify Deployment Issues

## Problem 1: Missing Environment Variables ✅ FIX THIS FIRST

Add these **4 critical variables** in Coolify's Environment Variables section:

```
KONG_HTTP_PORT=8000
KONG_HTTPS_PORT=8443
POOLER_PROXY_PORT_TRANSACTION=6543
DOCKER_SOCKET_LOCATION=/var/run/docker.sock
```

## Problem 2: Vector Service Failing

The `vector` service is failing because:
- It needs Docker socket access (might be restricted in Coolify)
- The `db` service depends on `vector` being healthy
- When `vector` fails, `db` can't start

### Solution Option 1: Use Coolify Override (Recommended)

I've created `docker-compose.coolify.yml` that makes the vector dependency less strict.

**In Coolify, configure:**
- **Docker Compose Files**: `docker-compose.yml,docker-compose.coolify.yml`
- This will use both files (main + override)

### Solution Option 2: Add All Environment Variables

Make sure you've added ALL environment variables from `docker/.env.example`:

**Critical ones:**
```
POSTGRES_PASSWORD=<your-password>
JWT_SECRET=<your-secret>
ANON_KEY=<your-key>
SERVICE_ROLE_KEY=<your-key>
DASHBOARD_USERNAME=admin
DASHBOARD_PASSWORD=<your-password>
SECRET_KEY_BASE=<your-secret>
VAULT_ENC_KEY=<your-key>
PG_META_CRYPTO_KEY=<your-key>
LOGFLARE_PUBLIC_ACCESS_TOKEN=<your-token>
LOGFLARE_PRIVATE_ACCESS_TOKEN=<your-token>
POOLER_TENANT_ID=<your-id>
```

**Ports:**
```
KONG_HTTP_PORT=8000
KONG_HTTPS_PORT=8443
POOLER_PROXY_PORT_TRANSACTION=6543
DOCKER_SOCKET_LOCATION=/var/run/docker.sock
```

**Database:**
```
POSTGRES_HOST=db
POSTGRES_DB=postgres
POSTGRES_PORT=5432
```

**And all others from `.env.example`**

## Quick Action Steps

1. **Add the 4 missing port variables** in Coolify
2. **Add `DOCKER_SOCKET_LOCATION=/var/run/docker.sock`**
3. **Try deploying again**
4. **If vector still fails**, use the `docker-compose.coolify.yml` override

## If Vector Still Fails

The vector service is for log collection. If it continues to fail:
1. Use the `docker-compose.coolify.yml` override file
2. Or disable vector temporarily (it's not critical for basic functionality)

## After Adding Variables

Redeploy and check logs. The vector service should start, and then `db` can start.

