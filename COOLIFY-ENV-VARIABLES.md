# Missing Environment Variables for Coolify

## Critical Missing Variables

Add these to Coolify's Environment Variables section:

```
KONG_HTTP_PORT=8000
KONG_HTTPS_PORT=8443
POOLER_PROXY_PORT_TRANSACTION=6543
DOCKER_SOCKET_LOCATION=/var/run/docker.sock
```

## All Required Environment Variables

Copy these from your local `docker/.env` file or use these defaults:

### Ports
```
KONG_HTTP_PORT=8000
KONG_HTTPS_PORT=8443
POOLER_PROXY_PORT_TRANSACTION=6543
```

### Database
```
POSTGRES_HOST=db
POSTGRES_DB=postgres
POSTGRES_PORT=5432
POSTGRES_PASSWORD=<your-generated-password>
```

### Secrets (Use your generated values!)
```
JWT_SECRET=<your-generated-jwt-secret>
ANON_KEY=<your-generated-anon-key>
SERVICE_ROLE_KEY=<your-generated-service-role-key>
DASHBOARD_USERNAME=admin
DASHBOARD_PASSWORD=<your-generated-password>
SECRET_KEY_BASE=<your-generated-secret>
VAULT_ENC_KEY=<your-generated-key>
PG_META_CRYPTO_KEY=<your-generated-key>
```

### Pooler
```
POOLER_TENANT_ID=<your-generated-tenant-id>
POOLER_DEFAULT_POOL_SIZE=20
POOLER_MAX_CLIENT_CONN=100
POOLER_DB_POOL_SIZE=5
```

### Logs/Analytics
```
LOGFLARE_PUBLIC_ACCESS_TOKEN=<your-generated-token>
LOGFLARE_PRIVATE_ACCESS_TOKEN=<your-generated-token>
DOCKER_SOCKET_LOCATION=/var/run/docker.sock
```

### API
```
PGRST_DB_SCHEMAS=public,storage,graphql_public
```

### Auth
```
SITE_URL=http://localhost:3000
ADDITIONAL_REDIRECT_URLS=
JWT_EXPIRY=3600
DISABLE_SIGNUP=false
API_EXTERNAL_URL=http://localhost:8000
ENABLE_EMAIL_SIGNUP=true
ENABLE_EMAIL_AUTOCONFIRM=false
SMTP_ADMIN_EMAIL=admin@example.com
SMTP_HOST=supabase-mail
SMTP_PORT=2500
SMTP_USER=fake_mail_user
SMTP_PASS=fake_mail_password
SMTP_SENDER_NAME=fake_sender
ENABLE_ANONYMOUS_USERS=false
ENABLE_PHONE_SIGNUP=true
ENABLE_PHONE_AUTOCONFIRM=true
MAILER_URLPATHS_CONFIRMATION=/auth/v1/verify
MAILER_URLPATHS_INVITE=/auth/v1/verify
MAILER_URLPATHS_RECOVERY=/auth/v1/verify
MAILER_URLPATHS_EMAIL_CHANGE=/auth/v1/verify
```

### Studio
```
STUDIO_DEFAULT_ORGANIZATION=Default Organization
STUDIO_DEFAULT_PROJECT=Default Project
SUPABASE_PUBLIC_URL=http://localhost:8000
IMGPROXY_ENABLE_WEBP_DETECTION=true
OPENAI_API_KEY=
```

### Functions
```
FUNCTIONS_VERIFY_JWT=false
```

## Quick Fix

The immediate errors are:
1. `KONG_HTTP_PORT` - Add: `8000`
2. `KONG_HTTPS_PORT` - Add: `8443`
3. `POOLER_PROXY_PORT_TRANSACTION` - Add: `6543`
4. `DOCKER_SOCKET_LOCATION` - Add: `/var/run/docker.sock`

Add these 4 first, then add the rest!

