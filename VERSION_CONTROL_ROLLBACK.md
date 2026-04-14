# Version Control & Rollback Procedure

##  Current Version Strategy

**Active Versions:**

```
main (development)
├── Latest development code
├── May include experimental features
└── Deployed on demand

production (stable)
├── Production-ready release
├── Tested and verified
└── Can be deployed to Render

render-deployment (web api)
├── REST API server code
├── Optimized for Render deployment
├── Uses Spring Boot + MongoDB
└── Includes Docker/Containerization

v1.0-desktop (tag - frozen)
├── Original desktop application
├── JavaFX GUI with local CSV/MongoDB
├── Fully functional standalone version
├── Preserved for reference & rollback
```

---

## ️ Tags & Releases

### Current Tags

```bash
# View all tags
git tag -l -n

# v1.0-desktop
# - Original desktop version
# - Fully tested
# - Can be checked out anytime
```

### Creating New Release Tags

```bash
# Tag current version as release
git tag -a v2.0-api -m "Spring Boot REST API release"

# Push tag to GitHub
git push origin v2.0-api
```

---

##  Rollback Procedures

### Scenario 1: Render Deployment Issue

**If the current Render deployment has issues:**

#### 1. Quick Rollback

```bash
# Switch Render deployment to previous working tag
git checkout v1.0-desktop
git push origin HEAD:render-deployment --force
```

#### 2. Push Stable Version

In Render dashboard:
1. Go to Service → Settings
2. Update **Branch** to `render-deployment`
3. Click **"Manual Deploy"** or wait for auto-redeploy
4. Monitor logs until status is "Live"

#### 3. Issue Diagnosis

While running stable version:
```bash
git checkout render-deployment
# Investigate and fix issues
git push origin render-deployment
git tag -a v2.0-api-hotfix -m "Fixed [issue description]"
git push origin v2.0-api-hotfix
```

---

### Scenario 2: Production Database Issues

**If production data is corrupted:**

#### 1. Don't Panic 

- MongoDB Atlas has automatic backups
- Your API code is versioned
- Desktop version has local CSV backups

#### 2. Restore from MongoDB Backup

```bash
# In MongoDB Atlas:
1. Go to "Backup" tab
2. Find automatic backup before issue occurred
3. Click "Restore" and follow prompts
4. Choose restore location (same cluster or new)
5. Restore to `ironpulse-backup` database first
6. Verify data integrity
7. If OK, restore to `ironpulse` production database
```

#### 3. Restart API

```bash
# In Render dashboard:
1. Go to Service → Settings
2. Click "Restart" button
3. API reconnects to restored database
4. Verify with test API call
```

---

### Scenario 3: Code Rollback

**If you need to revert code changes:**

#### 1. View Commit History

```bash
cd /workspaces/IronPluse

# See recent commits
git log --oneline -10

# Output example:
# abc1234 Fix member search bug
# def5678 Add payment filter
# ghi9012 (tag: v1.0-desktop) Update README
```

#### 2. Rollback to Previous Commit

```bash
# Option A: Soft rollback (keep changes, undo commit)
git revert abc1234

# Option B: Hard rollback (discard all changes)
git reset --hard def5678

# Push to branch
git push origin render-deployment --force
```

#### 3. Render Auto-Redeploys

Once pushed, Render automatically rebuilds and deploys new version.

---

### Scenario 4: Merge Conflicts During Release

**If render-deployment has conflicts with main:**

```bash
# Resolve on local machine first
git checkout render-deployment
git merge main

# If conflicts occur:
1. Fix conflicts in files
2. git add <fixed-files>
3. git commit -m "Resolve merge conflicts"
4. git push origin render-deployment
```

---

##  Version Comparison

### Desktop (v1.0-desktop)

```
 Pros:
  - Standalone executable
  - Works offline
  - Local data storage (CSV)
  - JavaFX UI
  - No server required

 Cons:
  - Single user
  - Limited scalability
  - Manual backup needed
  - Desktop installation required
```

### Web API (render-deployment)

```
 Pros:
  - Multi-user access
  - MongoDB cloud backup
  - Scalable architecture
  - REST API for integration
  - Automatic container scaling

 Cons:
  - Requires internet connection
  - Cloud database subscription
  - More complex deployment
  - Running costs
```

---

##  Migration Path: Desktop → Web

If moving users from desktop to web:

### 1. Data Migration

```bash
# Export from desktop CSV
cp data/members.csv members_backup.csv
cp data/payments.csv payments_backup.csv

# Run migration script (if available)
java -cp "lib/*:dist/IronPulse.jar" migrate.MigrateToMongoDB \
  --members-file members_backup.csv \
  --payments-file payments_backup.csv \
  --mongodb-uri "your-connection-string"
```

### 2. User Transition

1. Deploy web version to Render
2. Test with sample users
3. Migrate production database
4. Communicate new web URL to users
5. Keep desktop version available for reference

### 3. Gradual Rollout

- Week 1: Small user group tests web version
- Week 2: Expand to 50% of users
- Week 3: Full migration
- Month 1: Desktop available as fallback
- After: Sunset desktop version if not needed

---

##  Release Checklist

### Before Creating Release Tag

- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] No critical bugs known
- [ ] Changelog prepared
- [ ] Version number bumped (pom.xml)
- [ ] Commit message clear and descriptive

### Before Deploying to Render

- [ ] Release tag created
- [ ] Branch pushed to GitHub
- [ ] Environment variables verified
- [ ] MongoDB connection tested locally
- [ ] API endpoints tested locally
- [ ] Docker build successful locally
- [ ] No secrets in code/config

### After Deployment

- [ ] Health check endpoints responding
- [ ] API endpoints functional
- [ ] Database connected and accessible
- [ ] Logs showing no errors
- [ ] Performance acceptable
- [ ] Monitor for 1+ hours for issues

---

##  Maintenance Tasks

### Weekly

```bash
# Review logs and errors
# Check MongoDB storage usage
# Verify API response times
# Monitor for security issues
```

### Monthly

```bash
# Create backup of critical data
git tag -a vX.Y.Z-backup-$(date +%Y%m%d) \
  -m "Monthly backup - $(date)"
git push origin --tags

# Update dependencies
# Review and apply security patches
# Performance optimization review
```

### Quarterly

```bash
# Full disaster recovery test
# Load testing on staging environment
# Security audit
# Plan next major version features
```

---

## 🆘 Emergency Procedures

### Production Down!

**Steps (in order):**

1. **Verify Status** (2 min)
```bash
curl -I https://ironpulse-api.onrender.com/api/dashboard/overview
# Should return "200 OK" if working
```

2. **Check Logs** (3 min)
   - Render Dashboard → Logs tab
   - Look for errors or stack traces

3. **Restart Service** (1 min)
   - Render Dashboard → Settings → "Restart" button
   - Wait for status to return to "Live"

4. **Check Database** (2 min)
   - MongoDB Atlas → Clusters → View Monitoring
   - Ensure no connection errors

5. **Rollback if Needed** (5 min)
   - If issue persistent after restart
   - Deploy previous stable version
   - See "Scenario 1: Render Deployment Issue" above

6. **Notify Users** (1 min)
   - If extended outage (>15 min)
   - Post status update
   - Provide ETA

---

##  Support Contacts

- **Render Support**: [dashboard.render.com/support](https://dashboard.render.com)
- **MongoDB Support**: [support.mongodb.com](https://support.mongodb.com)
- **GitHub Issues**: [Your Repo Issues](https://github.com/Pranvkumar/IronPluse/issues)

---

##  Backup Verification

**Last Backup Test**: YYYY-MM-DD (UPDATE MANUALLY)

```bash
# To verify backups work:
1. Go to MongoDB Atlas → Backup
2. Select an old automatic backup
3. Restore Point-in-Time (PITR) to test database
4. Connect and verify data integrity
5. Delete test database
6. Update this date
```

---

System is production-ready with full rollback capabilities! 
