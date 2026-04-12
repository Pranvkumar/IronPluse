# IronPulse Pro - MongoDB + HTML/CSS Integration Guide

## 🚀 Setup Instructions

### Prerequisites
- MongoDB installed and running on `localhost:27017`
- Java JDK 11 or higher
- MongoDB Java Driver 5.1.4 (already in `/lib` folder)

### Step 1: Start MongoDB Server

```bash
# macOS (using Homebrew)
brew services start mongodb-community

# Linux (Ubuntu/Debian)
sudo systemctl start mongod

# Windows
net start MongoDB

# Docker (alternative)
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### Step 2: Compile and Run

```bash
cd IronPluse

# Compile the project
javac -cp "lib/*:src" -d out src/ironpulse/**/*.java

# Run the application
java -cp "lib/*:out" ironpulse.Main
```

### Step 3: Login Credentials
- **Username:** `admin`
- **Password:** `ironpulse123`

---

## 📊 Features

### HTML/CSS Styled UI Components
The application now includes:
- **Styled Dashboard** - HTML/CSS cards for member statistics
- **Activity Logger** - Formatted activity display
- **Alert System** - Success/Error/Info notifications
- **Member Cards** - Beautiful member profile displays

### MongoDB Integration
- **Automatic Data Persistence** - Members and payments saved to MongoDB
- **Collections:**
  - `members` - Stores member information
  - `payments` - Stores payment records
- **CRUD Operations:**
  - Create: Insert members and payments
  - Read: Load data from MongoDB
  - Update: Modify member information
  - Delete: Remove members and their records

### Key Technologies
```
├── Swing UI Framework
├── MongoDB Database
├── HTML/CSS Styling
├── BSON Documents
└── RESTful Data Models
```

---

## 📁 Project Structure

```
IronPluse/
├── src/ironpulse/
│   ├── ui/
│   │   ├── MainFrame.java          (Updated with MongoDB integration)
│   │   └── StyledUIComponent.java  (NEW - HTML/CSS styles)
│   ├── storage/
│   │   └── MongoDBConnection.java  (NEW - Database operations)
│   ├── model/
│   ├── service/
│   └── exception/
├── lib/
│   ├── mongodb-driver-core-5.1.4.jar
│   ├── mongodb-driver-sync-5.1.4.jar
│   └── bson-5.1.4.jar
└── out/ (compiled classes)
```

---

## 🔧 Configuration

### MongoDB Connection String
Located in `MongoDBConnection.java`:
```java
private static final String CONNECTION_STRING = "mongodb://localhost:27017";
private static final String DATABASE_NAME = "ironpulse_db";
```

### Modify Connection
Edit these constants if your MongoDB is running on a different host:
```java
// Example for MongoDB Atlas:
private static final String CONNECTION_STRING = "mongodb+srv://username:password@cluster.mongodb.net/";
```

---

## 📈 Usage Examples

### Adding a Member (Auto-saves to MongoDB)
1. Click "Member Management"
2. Click "Add Member"
3. Fill in the form
4. Click "Save"
5. ✓ Member is saved to both in-memory storage AND MongoDB automatically

### Processing Payment (Auto-saves to MongoDB)
1. Click "Payments"
2. Click "Process Payment"
3. Select member and enter amount
4. Click "Save"
5. ✓ Payment is recorded in both systems

### Viewing Stored Data
```bash
# Connect to MongoDB shell
mongosh

# View all members
use ironpulse_db
db.members.find().pretty()
db.payments.find().pretty()
```

---

## 🎨 HTML/CSS Features

The `StyledUIComponent.java` provides pre-built styled components:

```java
// Create styled dashboard
StyledUIComponent.createStyledEditorPane()

// Generate HTML for stats
StyledUIComponent.createStatsHTML(members, active, revenue, pending)

// Create alert messages
StyledUIComponent.createAlertHTML("success", "Operation completed!")
```

### Styling Highlights
- Gradient backgrounds
- Hover effects on cards
- Responsive grid layout
- Color-coded status badges
- Professional typography

---

## 🔍 Troubleshooting

### MongoDB Connection Failed
```
✗ MongoDB connection failed: Connection refused
```
**Solution:** Ensure MongoDB is running
```bash
# Check if MongoDB is running
mongosh

# If not, start it:
brew services start mongodb-community  # macOS
sudo systemctl start mongod            # Linux
net start MongoDB                       # Windows
```

### Compilation Errors
```
error: cannot find symbol: class MongoDBConnection
```
**Solution:** Ensure all source files are compiled:
```bash
javac -cp "lib/*:src" -d out src/ironpulse/**/*.java
```

### ClassNotFoundException
```
java.lang.ClassNotFoundException: com.mongodb.client.MongoClient
```
**Solution:** Ensure MongoDB drivers are in classpath:
```bash
java -cp "lib/*:out" ironpulse.Main
```

---

## 📊 Database Schema

### Members Collection
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
  "memberType": "REGULAR",
  "timestamp": 1712745600000
}
```

### Payments Collection
```json
{
  "_id": "PAY-98765",
  "memberId": "MEM-12345",
  "amount": 60.00,
  "timestamp": "2024-04-10T14:30:00",
  "status": "PAID",
  "receiptNote": "Receipt #PAY-98765",
  "databaseTimestamp": 1712758200000
}
```

---

## 🚀 Next Steps

1. **Backup Configuration** - Set up MongoDB backups
2. **Advanced Queries** - Implement filtering and aggregation
3. **Cloud Deployment** - Use MongoDB Atlas for cloud hosting
4. **UI Enhancements** - Add more HTML/CSS styled components
5. **API Integration** - Expose REST endpoints for external access

---

## 📝 Notes

- All data operations automatically sync with MongoDB
- In-memory storage remains as primary operation store
- MongoDB acts as persistent backup and audit trail
- Connection failures don't crash the application
- Console logs show all MongoDB operations

---

## 💡 Tips

- Check console logs for MongoDB operation confirmations
- Use MongoDB Compass for visual database management
- Export reports to track payment history
- Toggle theme button for dark/light mode
- Search functionality works across all fields

---

## 📞 Support

For issues or questions:
1. Check the console output for detailed error messages
2. Verify MongoDB is running: `mongosh`
3. Review collection structure: `db.members.findOne()`
4. Check connection string in `MongoDBConnection.java`

---

**Version:** 1.0
**Last Updated:** April 2026
**Database:** MongoDB 5.1.4
