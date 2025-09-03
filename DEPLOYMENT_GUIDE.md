# Pharmint Marketplace Deployment Guide

## Production Deployment Summary

This guide documents the complete deployment of the Pharmint pharmaceutical marketplace on Google Cloud Platform (GCP) server `35.232.198.119`.

## Final Architecture

- **Frontend**: https://pharmint.ph (Next.js on port 8000)
- **Admin Panel**: https://admin.pharmint.ph/app (Medusa Admin)
- **API Backend**: https://api.pharmint.ph (Medusa v2 on port 9000)
- **Database**: PostgreSQL (local on port 5432)
- **Process Manager**: PM2 with systemd integration
- **Reverse Proxy**: Nginx with SSL certificates

## Deployment Steps

### 1. Initial Setup and Cleanup
```bash
# Stop all existing PM2 processes
pm2 stop all && pm2 delete all

# Clean up old files and database
sudo -u postgres dropdb pharmint_old 2>/dev/null || true
rm -rf old_deployment_files
```

### 2. Repository and Database Setup
```bash
# Clone/update repository
cd /home/mukul
git clone https://github.com/your-org/pharmint-marketplace.git
cd pharmint-marketplace
git pull origin main

# Database restoration
sudo -u postgres createdb pharmint
sudo -u postgres psql -d pharmint -f pharmint-seed-20250903.sql

# Enable pgcrypto extension
sudo -u postgres psql -d pharmint -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
```

### 3. Backend Configuration
```bash
# Navigate to backend
cd backend

# Configure environment variables (.env)
STORE_CORS=https://pharmint.ph
ADMIN_CORS=https://admin.pharmint.ph
AUTH_CORS=https://admin.pharmint.ph
JWT_SECRET=<random-secret>
COOKIE_SECRET=<random-secret>
DATABASE_URL=postgresql://postgres:pharmint123@localhost:5432/pharmint
REDIS_URL=redis://localhost:6379
NODE_ENV=production
DISABLE_MEDUSA_ADMIN=false
MEDUSA_WORKER_MODE=server
MEDUSA_BACKEND_URL=https://api.pharmint.ph
BACKEND_URL=https://api.pharmint.ph
MEDUSA_ADMIN_BACKEND_URL=https://api.pharmint.ph

# Install dependencies and build
yarn install
yarn build
```

### 4. Frontend Configuration
```bash
# Navigate to frontend
cd ../frontend

# Configure environment variables (.env.local)
MEDUSA_BACKEND_URL=https://api.pharmint.ph
NEXT_PUBLIC_DEFAULT_REGION=ph
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_34d11f50308c12a3bf2e970e3759373236a288ec6d84d8e947436d8a0a74165b
REVALIDATE_SECRET=supersecret

# Install dependencies and build
yarn install
yarn build
```

### 5. Admin User Creation
```bash
# Create admin user using Medusa CLI
cd backend
npx medusa user --email mukulyadav49@gmail.com --password AqSA5dvbsPYm
```

### 6. PM2 Deployment
```bash
# Start backend service
cd backend/.medusa/server
pm2 start npm --name 'pharmint-backend' -- run start

# Start frontend service  
cd ../../frontend
pm2 start "npm run start" --name 'pharmint-frontend'

# Save PM2 configuration and setup auto-start
pm2 save
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u mukul --hp /home/mukul
```

### 7. Nginx Configuration
```nginx
# /etc/nginx/sites-available/pharmint.ph
server {
    listen 443 ssl;
    server_name api.pharmint.ph;
    
    ssl_certificate /etc/letsencrypt/live/pharmint.ph/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/pharmint.ph/privkey.pem;
    
    location / {
        proxy_pass http://localhost:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl;
    server_name pharmint.ph;
    
    ssl_certificate /etc/letsencrypt/live/pharmint.ph/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/pharmint.ph/privkey.pem;
    
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl;
    server_name admin.pharmint.ph;
    
    ssl_certificate /etc/letsencrypt/live/pharmint.ph/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/pharmint.ph/privkey.pem;
    
    location / {
        proxy_pass http://localhost:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Incorrect Assumptions & Fixes

### ❌ Assumption 1: Running from Project Root
**Incorrect Approach:**
```bash
cd backend
npm run start  # Running from backend root
```

**Issue:** Admin panel was not accessible, getting 404 errors.

**✅ Correct Approach (Official Medusa Way):**
```bash
cd backend/.medusa/server
npm run start  # Running from .medusa/server directory
```

**Why:** Medusa v2 official deployment requires running from the `.medusa/server` directory where the compiled application resides.

### ❌ Assumption 2: Frontend Environment Variable Naming
**Incorrect Approach:**
```env
NEXT_PUBLIC_MEDUSA_BACKEND_URL=https://api.pharmint.ph
```

**Issue:** Frontend 500 errors with middleware failing to fetch regions.

**✅ Correct Approach:**
```env
MEDUSA_BACKEND_URL=https://api.pharmint.ph
```

**Why:** Medusa v2 changed the environment variable naming convention. The middleware expects `MEDUSA_BACKEND_URL`, not `NEXT_PUBLIC_MEDUSA_BACKEND_URL`.

### ❌ Assumption 3: Development vs Production Mode
**Incorrect Approach:**
```bash
npm run build
NODE_ENV=production npm run start
```

**Issue:** Admin panel build was incomplete, various functionality missing.

**✅ Correct Approach:**
```bash
yarn build  # Uses official Medusa build process
yarn start  # Or npm run start from .medusa/server
```

**Why:** Following the official Medusa deployment documentation ensures proper build compilation and admin panel functionality.

### ❌ Assumption 4: CORS Configuration
**Incorrect Approach:**
```env
ADMIN_CORS=https://admin.pharmint.ph,http://localhost:9000,http://localhost:5173
```

**Issue:** File exports were generating localhost URLs instead of production URLs.

**✅ Correct Approach:**
```env
ADMIN_CORS=https://admin.pharmint.ph
STORE_CORS=https://pharmint.ph
AUTH_CORS=https://admin.pharmint.ph
MEDUSA_BACKEND_URL=https://api.pharmint.ph
```

**Why:** Removing localhost references and setting proper backend URL ensures file exports use production domains.

### ❌ Assumption 5: Manual Process Management
**Incorrect Approach:**
```bash
nohup npm run start &  # Manual background processes
```

**Issue:** Processes would die when SSH session ended, no automatic restart on crashes.

**✅ Correct Approach:**
```bash
pm2 start npm --name 'pharmint-backend' -- run start
pm2 start "npm run start" --name 'pharmint-frontend'
pm2 save
pm2 startup
```

**Why:** PM2 provides process management, automatic restarts, and systemd integration for production environments.

## Key Lessons Learned

1. **Always follow official deployment guides** - Custom approaches often miss critical configurations
2. **Environment variables matter** - Medusa v2 has specific naming conventions that differ from v1
3. **Process management is crucial** - Manual processes don't survive production scenarios
4. **CORS and backend URLs affect file services** - Localhost references cause production issues
5. **Database extensions required** - pgcrypto needed for proper password hashing
6. **Build from correct directory** - Medusa v2 requires running from `.medusa/server` for admin functionality

## Health Checks

After deployment, verify:

```bash
# Backend health
curl https://api.pharmint.ph/health

# Frontend loading
curl -I https://pharmint.ph

# Admin panel access
curl -I https://admin.pharmint.ph/app

# PM2 status
pm2 status
```

## Admin Credentials

- **Email:** mukulyadav49@gmail.com
- **Password:** AqSA5dvbsPYm
- **Admin URL:** https://admin.pharmint.ph/app

## Production URLs

- **Storefront:** https://pharmint.ph
- **Admin Panel:** https://admin.pharmint.ph/app  
- **API Endpoint:** https://api.pharmint.ph
- **Health Check:** https://api.pharmint.ph/health

---

**Deployment Date:** September 3, 2025  
**Medusa Version:** v2.4  
**Next.js Version:** 15.5.2  
**Server:** Google Cloud Platform (35.232.198.119)