# IronPulse Render Deployment Guide

## 📋 Overview

This guide covers deploying IronPulse to Render with:
- ✅ MongoDB Atlas for database
- ✅ REST API (Spring Boot) for backend
- ✅ Previous desktop version preserved (v1.0-desktop tag)
- ✅ Automatic scaling and zero downtime

---

## 🎯 Architecture

```
┌─────────────────────────────────────────────────────┐
│         Frontend (React/Vue) - Port 3000             │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│   Render Web Service (IronPulse API) - Port 8080     │
│        (Spring Boot REST Application)                │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│     MongoDB Atlas - Finmind Cluster                  │
│   (AWS Mumbai - ap-south-1)                          │
└─────────────────────────────────────────────────────┘
```

---

## 🚀 Pre-Deployment Checklist

- [ ] MongoDB Atlas cluster "Finmind" is **Available**
- [ ] Database user created (`ironpulse_user`)
- [ ] Connection string obtained from Atlas
- [ ] IP address whitelisted in Network Access
- [ ] Render account created
- [ ] Repository pushed to GitHub

---

## 📝 Step 1: Prepare MongoDB Atlas

### 1.1 Verify Cluster Status

```bash
# Login to MongoDB Atlas -> Clusters
# Click on "Finmind" cluster
# Confirm status: "Available" (green checkmark)
```

### 1.2 Create Database User

1. Go to **Security** → **Database Access**
2. Click **"+ Add New Database User"**
3. Enter:
   - **Username**: `ironpulse_user`
   - **Password**: Generate strong password (save securely!)
   - **Role**: `readWriteAnyDatabase`
4. Click **"Add User"**

### 1.3 Get Connection String

1. In **Finmind** cluster, click **"Connect"**
2. Select **"Drivers"** → **Java** → **5.1 or later**
3. Copy the connection string
4. Replace placeholders:
   - `<username>` → `ironpulse_user`
   - `<password>` → Your user password
   - `/test` → `/ironpulse`

**Result example:**
```
mongodb+srv://ironpulse_user:YOUR_PASSWORD@finmind.xxxxx.mongodb.net/ironpulse?retryWrites=true&w=majority
```

### 1.4 Configure Network Access

1. Go to **Security** → **Network Access**
2. Click **"+ Add IP Address"**
3. Select **"Allow access from anywhere"** (0.0.0.0/0)
4. Add comment: "Render deployment"
5. Click **"Confirm"**

⚠️ **For production:** Whitelist specific Render IPs instead of allowing all.

---

## 🐳 Step 2: Deploy to Render

### 2.1 Connect Repository

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Web Service"**
3. Select **"Build and deploy from a Git repository"**
4. Connect your GitHub account
5. Select repository: `IronPluse`
6. Branch: `render-deployment`

### 2.2 Configure Deployment

**Basic Settings:**
- **Name**: `ironpulse-api`
- **Runtime**: `Java`
- **Build Command**: `bash build-render.sh`
- **Start Command**: `java -cp "lib/*:dist/IronPulse-API.jar" com.ironpulse.IronPulseAPIApplication`
- **Plan**: Free (or Pro if needed)

### 2.3 Add Environment Variables

Click **"Advanced"** → **"Add Environment Variable"**

Add these variables:

| Key | Value | Notes |
|-----|-------|-------|
| `MONGO_URI` | `mongodb+srv://ironpulse_user:PASSWORD@finmind.xxxxx.mongodb.net/ironpulse?retryWrites=true&w=majority` | From Step 1.3 |
| `PORT` | `8080` | Default Render port |
| `ENVIRONMENT` | `production` | Deployment environment |
| `JAVA_TOOL_OPTIONS` | `-Xmx512m -Xms256m` | Memory settings |
| `ADMIN_USERNAME` | `admin` | Default admin user |
| `ADMIN_PASSWORD` | Your secure password | Change from default! |

### 2.4 Deploy

1. Click **"Create Web Service"**
2. Render starts building and deploying
3. Monitor logs in the deployment dashboard
4. Once **Status = "Live"**, your app is running

**Your API URL:** `https://ironpulse-api.onrender.com`

---

## ✅ Step 3: Verify Deployment

### 3.1 Test API Health

```bash
# Check if API is running
curl https://ironpulse-api.onrender.com/api/dashboard/overview

# Expected response:
# {
#   "totalMembers": 0,
#   "activeMembers": 0,
#   ...
# }
```

### 3.2 Test Member API

```bash
# Get all members
curl https://ironpulse-api.onrender.com/api/members

# Create new member
curl -X POST https://ironpulse-api.onrender.com/api/members \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "9876543210",
    "age": 30,
    "status": "ACTIVE",
    "membershipPlan": "Premium"
  }'
```

### 3.3 Check MongoDB Connection

```bash
# View logs in Render dashboard
# Look for successful MongoDB connection messages
# Example: "Connected to MongoDB successfully"
```

---

## 🔄 Step 4: Connect Frontend (Optional)

If you have a frontend (React/Vue):

1. Update API base URL in frontend `.env`:
   ```
   REACT_APP_API_URL=https://ironpulse-api.onrender.com/api
   ```

2. Deploy frontend to Render or Vercel
3. Update CORS in application.yml if needed

---

## 📚 API Endpoints

### Members

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/members` | Get all members |
| GET | `/api/members/{id}` | Get member details |
| POST | `/api/members` | Create new member |
| PUT | `/api/members/{id}` | Update member |
| DELETE | `/api/members/{id}` | Delete member |
| GET | `/api/members/search?query=name` | Search members |
| GET | `/api/members/stats/summary` | Member statistics |

### Payments

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/payments` | Get all payments |
| GET | `/api/payments/{id}` | Get payment details |
| POST | `/api/payments` | Record new payment |
| PUT | `/api/payments/{id}/status` | Update payment status |
| GET | `/api/payments/member/{memberId}` | Get member's payments |
| GET | `/api/payments/stats/revenue` | Revenue statistics |

### Dashboard

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/dashboard/overview` | Dashboard overview |
| GET | `/api/dashboard/revenue` | Revenue data |
| GET | `/api/dashboard/members/distribution` | Member distribution |
| GET | `/api/dashboard/activities/recent` | Recent activities |

---

## 🔄 Maintaining Previous Versions

### Access Desktop Version

```bash
# The desktop version is preserved at tag v1.0-desktop
git checkout v1.0-desktop

# This contains the original JavaFX + CSV/MongoDB system
# Binary: dist/IronPulse.jar
# Run: java -cp "lib/*:dist/IronPulse.jar" ironpulse.Main
```

### Version Branches

```bash
git branch -a

* render-deployment    # Current Render deployment
  production          # Production-ready version
  main                # Development version
  
# Tags
v1.0-desktop         # Original desktop release (stable)
```

---

## 🚨 Troubleshooting

### "Failed to connect to MongoDB"

**Solutions:**
1. Verify `MONGO_URI` environment variable in Render
2. Check IP address is whitelisted in Atlas Network Access
3. Verify database user exists and password is correct
4. Check Atlas cluster status is "Available"

### "Build failed"

**Solutions:**
1. Check build logs in Render dashboard
2. Verify Java 21 is available
3. Ensure all dependencies are in pom.xml
4. Check build-render.sh has execute permissions

### "Port 8080 already in use"

**Solutions:**
1. Render auto-manages ports, shouldn't occur
2. Check for process conflicts in container
3. Restart the service from Render dashboard

### "API endpoint returns 404"

**Solutions:**
1. Verify API URL: `https://ironpulse-api.onrender.com/api/...`
2. Check endpoint spelling and HTTP method
3. Verify backend is running (`Status = "Live"`)

---

## 🔐 Security Best Practices

1. **Never commit `.env` file** with real credentials
2. **Use strong passwords** for MongoDB user
3. **Whitelist specific IPs** for MongoDB in production
4. **Enable HTTPS** (Render does this automatically)
5. **Rotate JWT secrets** periodically
6. **Monitor API logs** for suspicious activity
7. **Implement rate limiting** as configured

---

## 📊 Monitoring

### View Logs

1. Go to Render Dashboard
2. Select `ironpulse-api` service
3. Click **"Logs"** tab
4. View real-time logs and error messages

### Performance Metrics

1. Click **"Metrics"** tab
2. Monitor:
   - CPU usage
   - Memory usage
   - Requests per minute
   - Response times

---

## 🔄 Updating Deployment

To update the running application:

1. Make changes in `render-deployment` branch
2. Push to GitHub: `git push origin render-deployment`
3. Render automatically re-deploys on push
4. Monitor logs for build progress

---

## 🆘 Support & Resources

- [Render Documentation](https://render.com/docs)
- [MongoDB Atlas Docs](https://docs.atlas.mongodb.com/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Java Deployment Guide](https://www.oracle.com/java/technologies/)

---

## 📝 Next Steps

1. ✅ Configure MongoDB Atlas (waiting for Finmind cluster)
2. ✅ Deploy to Render using render.yaml
3. ⏳ Set up frontend (if using web UI)
4. ⏳ Configure custom domain (optional)
5. ⏳ Set up monitoring and alerts

**Current Status**: Deployment configuration ready
**Next Action**: Deploy to Render once MongoDB is ready
