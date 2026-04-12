# IronPulse Pro - Quick Start Guide

## 🎯 What's New?

Your IronPulse Pro Gym Management System now includes:

✅ **HTML/CSS Styled UI** - Beautiful, modern dashboard with gradient backgrounds
✅ **MongoDB Integration** - Persistent data storage with automatic sync
✅ **Styled Components** - Professional cards, alerts, and panels
✅ **Auto-Save** - Members and payments save to MongoDB automatically

---

## ⚡ 5-Minute Setup

### Step 1: Start MongoDB
Choose your platform:

**macOS:**
```bash
brew services start mongodb-community
```

**Linux (Ubuntu):**
```bash
sudo systemctl start mongod
```

**Windows:**
```bash
net start MongoDB
```

**Docker (any platform):**
```bash
docker run -d -p 27017:27017 --name ironpulse-mongo mongo:latest
```

### Step 2: Compile
```bash
cd IronPluse
javac -cp "lib/*:src" -d out src/ironpulse/**/*.java
```

### Step 3: Run
```bash
java -cp "lib/*:out" ironpulse.Main
```

### Step 4: Login
- **Username:** `admin`
- **Password:** `ironpulse123`

✓ **Done!** You're ready to use IronPulse Pro!

---

## 📊 New Features Overview

### 1. **Styled Dashboard**
- Beautiful stat cards with hover effects
- Color-coded metrics (Primary/Success/Warning/Danger)
- Gradient backgrounds
- Real-time updates

### 2. **MongoDB Storage**
```
Collections:
├── members (stores member data)
└── payments (stores payment records)
```

**Automatic Operations:**
- ✓ New member added → Saved to MongoDB
- ✓ Payment processed → Saved to MongoDB
- ✓ Member updated → Updated in MongoDB

### 3. **HTML/CSS Components**

#### Stat Cards
```java
JPanel card = StyledPanelBuilder.createStatCard(
    "Total Members", "156", "↑ 2.5%", "primary"
);
```

#### Alert Messages
```java
JPanel alert = StyledPanelBuilder.createAlertPanel(
    "Member registered successfully!", "success"
);
```

#### Member Cards
```java
JPanel member = StyledPanelBuilder.createMemberCard(
    "MEM-001", "John Doe", "Premium", "Active"
);
```

---

## 🔄 Data Flow

### When You Add a Member:
```
1. Fill form in UI
2. Click "Save"
3. ↓ Saved to in-memory (GymManager)
4. ↓ Saved to MongoDB
5. ↓ Dashboard refreshes
6. ✓ Member appears in table
```

### When You Process a Payment:
```
1. Select member
2. Enter amount
3. Click "Save"
4. ↓ Saved to in-memory (GymManager)
5. ↓ Saved to MongoDB
6. ↓ Invoice generated
7. ✓ Payment appears in payments table
```

---

## 📁 File Structure

### New Files:
```
src/ironpulse/
├── storage/
│   └── MongoDBConnection.java  ✨ NEW
├── ui/
│   ├── StyledUIComponent.java   ✨ NEW
│   ├── StyledPanelBuilder.java  ✨ NEW
│   └── MainFrame.java           ⭐ UPDATED
```

### Documentation:
```
IronPulse/
├── MONGODB_SETUP.md             ✨ NEW (detailed setup guide)
├── INTEGRATION_EXAMPLES.java    ✨ NEW (code examples)
└── QUICK_START.md               ✨ NEW (this file)
```

---

## 💾 Data Persistence

### What Gets Saved to MongoDB?

**Members Collection:**
```json
{
  "_id": "MEM-12345",
  "fullName": "John Doe",
  "contact": "555-1234",
  "age": 28,
  "joiningDate": "2024-01-15",
  "status": "ACTIVE",
  "planName": "Premium",
  "planDuration": "MONTHLY",
  "memberType": "REGULAR"
}
```

**Payments Collection:**
```json
{
  "_id": "PAY-98765",
  "memberId": "MEM-12345",
  "amount": 60.00,
  "timestamp": "2024-04-10T14:30:00",
  "status": "PAID",
  "receiptNote": "Receipt #PAY-98765"
}
```

---

## 🎨 UI Themes

### Available Themes:
- **Light Mode** (Default)
- **Dark Mode** (Click "Toggle Theme" button)

### Color Scheme:
- **Primary:** Purple/Blue Gradient
- **Success:** Green
- **Warning:** Orange
- **Danger:** Red

---

## 🔧 Configuration

### Change MongoDB Connection:
Edit `src/ironpulse/storage/MongoDBConnection.java`:

```java
// Line 20-21
private static final String CONNECTION_STRING = "mongodb://localhost:27017";
private static final String DATABASE_NAME = "ironpulse_db";
```

### For MongoDB Atlas (Cloud):
```java
private static final String CONNECTION_STRING =
    "mongodb+srv://username:password@cluster.mongodb.net/";
private static final String DATABASE_NAME = "ironpulse_db";
```

---

## ✅ Verification

### Check MongoDB Connection:
```bash
mongosh
> use ironpulse_db
> db.members.count()      # Should show member count
> db.payments.count()     # Should show payment count
```

### Check Console Logs:
Look for these messages when you start the app:
```
✓ Connected to MongoDB successfully
✓ MongoDB integration initialized successfully
✓ Member saved to MongoDB: MEM-12345
✓ Payment saved to MongoDB: PAY-98765
```

---

## 🐛 Troubleshooting

### MongoDB Not Starting?
```bash
# Check if MongoDB is running
mongo --version

# Try starting with brew
brew services restart mongodb-community

# Or use Docker
docker run -d -p 27017:27017 mongo:latest
```

### Compilation Error?
```bash
# Make sure you're in the IronPluse directory
cd IronPluse

# Recompile everything
rm -rf out
javac -cp "lib/*:src" -d out src/ironpulse/**/*.java
```

### Connection Refused?
```
✗ MongoDB connection failed: Connection refused
→ Ensure MongoDB is running: mongosh
→ Before starting the application
```

---

## 📖 Usage Examples

### View All Members in MongoDB:
```bash
mongosh
> use ironpulse_db
> db.members.find().pretty()
```

### View All Payments:
```bash
> db.payments.find().pretty()
```

### Find Active Members:
```bash
> db.members.find({"status": "ACTIVE"}).count()
```

### Calculate Total Revenue:
```bash
> db.payments.aggregate([
    {$group: {_id: null, total: {$sum: "$amount"}}}
  ])
```

---

## 🚀 Next Steps

1. **Start the app:** `java -cp "lib/*:out" ironpulse.Main`
2. **Add members:** Click "Member Management" → "Add Member"
3. **Process payments:** Click "Payments" → "Process Payment"
4. **Check MongoDB:** `mongosh` → `db.members.find().pretty()`
5. **Export reports:** Use the "Export" buttons in the UI

---

## 📞 Need Help?

Check the detailed setup guide: `MONGODB_SETUP.md`
View code examples: `INTEGRATION_EXAMPLES.java`

---

## 📋 Checklist

Before starting:
- [ ] MongoDB installed
- [ ] MongoDB running (test with `mongosh`)
- [ ] Java 11+ installed
- [ ] All files compiled successfully
- [ ] `lib/` folder contains JAR files

After starting:
- [ ] Login successful (admin/ironpulse123)
- [ ] Dashboard loads with stats
- [ ] Can add members
- [ ] Can process payments
- [ ] MongoDB console shows data

---

## 🎉 Success!

Your IronPulse Pro system with HTML/CSS styling and MongoDB is ready to use!

**Features Summary:**
✓ Beautiful modern UI
✓ Persistent database storage
✓ Auto-save functionality
✓ Professional styling
✓ Scalable architecture

**Happy gym managing! 🏋️💪**

---

**Version:** 1.0
**Database:** MongoDB 5.1.4
**Framework:** Java Swing
**Last Updated:** April 2026
