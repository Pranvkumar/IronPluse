# MongoDB Atlas Setup Guide for IronPulse

##  Prerequisites
- MongoDB Atlas account (you have this )
- Active cluster (Finmind - currently provisioning)

---

##  Step 1: Wait for Cluster to be Ready

Your **Finmind** cluster is currently provisioning. This takes 1-3 minutes.

**Check Status:**
- Go to MongoDB Atlas Dashboard
- Click on "Clusters" (left sidebar)
- Wait for status to show **"Available"** (green checkmark)

---

##  Step 2: Create Database User

Once cluster is ready:

1. Click on **Finmind** cluster
2. Go to **"Security"** → **"Database Access"** (left menu)
3. Click **"+ Add New Database User"**
4. Fill in:
   - **Username:** `ironpulse_user`
   - **Password:** Choose strong password (or generate)
   - **Built-in Role:** `readWriteAnyDatabase`
5. Click **"Add User"**

**Save credentials securely!**

---

##  Step 3: Get Connection String

1. In **Finmind** cluster, click **"Connect"** button
2. Choose **"Drivers"**
3. Select:
   - **Driver:** Java
   - **Version:** 5.1 or later
4. Copy the connection string
   - Replace `<username>` with `ironpulse_user`
   - Replace `<password>` with your user password
   - Replace `/test` database name with `/ironpulse`

**Example format:**
```
mongodb+srv://ironpulse_user:YOUR_PASSWORD@finmind.xxxxx.mongodb.net/ironpulse?retryWrites=true&w=majority
```

---

##  Step 4: Configure Environment Variables

### On Render:

1. Go to your Render service settings
2. Add environment variable:
   - **Name:** `MONGO_URI`
   - **Value:** Your connection string (from Step 3)

### Locally (for testing):

Create `.env` file in project root:
```bash
# Copy from .env.example
cp .env.example .env

# Edit .env and add:
MONGO_URI=mongodb+srv://ironpulse_user:YOUR_PASSWORD@finmind.xxxxx.mongodb.net/ironpulse?retryWrites=true&w=majority
```

---

##  Step 5: Configure Network Access

**Important for Render deployment:**

1. Go to **"Security"** → **"Network Access"** in Atlas
2. Click **"+ Add IP Address"**
3. Options:
   - **For Render:** Click **"Allow access from anywhere"** (0.0.0.0/0)
   - Add comment: "Render deployment"
4. Click **"Confirm"**

️ **Security Note:** For production, whitelist specific Render IPs instead.

---

## 6️⃣ Step 6: Create Collections (Optional)

The application will auto-create collections, but you can pre-create them:

**Via Atlas UI:**
1. Click **"Browse Collections"**
2. Click **"Create Database"**
3. Database name: `ironpulse`
4. Collection name: `members`
5. Repeat for collections: `payments`, `memberships`, `invoices`

---

##  Step 7: Test Connection

### Test connection locally:
```bash
# From project root
java -cp "lib/*:out" com.ironpulse.MongoTest
```

### Or use MongoDB Compass:
1. Download [MongoDB Compass](https://www.mongodb.com/products/compass)
2. Paste connection string
3. Click "Connect"
4. Verify `ironpulse` database and collections

---

##  Troubleshooting

### Connection Error: "Authentication failed"
- Verify username/password in connection string
- Check that user exists in Database Access tab
- Ensure password has no special characters needing URL encoding

### Connection Error: "Network timeout"
- Verify IP address is whitelisted in Network Access
- Ensure VPN/firewall isn't blocking MongoDB port (27017)

### Collections not visible
- Run the application once to auto-create
- Or manually create via Collections browser

---

##  Render Deployment Integration

The REST API will automatically:
1. Read `MONGO_URI` environment variable
2. Connect to Atlas cluster
3. Auto-create collections if missing
4. Sync data between frontend and MongoDB

No additional configuration needed after setting `MONGO_URI`!

---

##  Useful Resources

- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Java Driver Connection Guide](https://www.mongodb.com/docs/drivers/java/sync/current/quick-start/connect-to-mongodb/)
- [Render Environment Variables](https://render.com/docs/environment-variables)
