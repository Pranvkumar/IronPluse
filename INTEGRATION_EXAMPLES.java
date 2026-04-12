/**
 * IronPulse Pro - HTML/CSS + MongoDB Integration Examples
 *
 * This file demonstrates how to use the new HTML/CSS styling and MongoDB features
 * in the IronPulse Pro Gym Management System.
 *
 * @author Development Team
 * @version 1.0
 */

// ============================================================================
// PART 1: HTML/CSS STYLED COMPONENTS
// ============================================================================

/*
 * EXAMPLE 1: Creating Styled Stat Cards
 * ======================================
 *
 * The new StyledPanelBuilder class provides easy-to-use methods for creating
 * beautiful HTML/CSS styled components.
 */

// Create a stat card showing membership statistics
JPanel memberStats = StyledPanelBuilder.createStatCard(
    "Total Members",           // label
    "156",                     // value
    "↑ 2.5% from last month",  // change indicator
    "primary"                  // type (primary, success, warning, danger)
);

// Create revenue card
JPanel revenueStats = StyledPanelBuilder.createStatCard(
    "Monthly Revenue",
    "$12,450.50",
    "↑ 15% from last month",
    "success"
);

// Create pending payments alert
JPanel pendingStats = StyledPanelBuilder.createStatCard(
    "Pending Payments",
    "23",
    "Requires attention",
    "warning"
);


/*
 * EXAMPLE 2: Creating Alert Messages
 * ===================================
 */

// Success alert
JPanel successAlert = StyledPanelBuilder.createAlertPanel(
    "✓ Member registration successful!",
    "success"
);

// Error alert
JPanel errorAlert = StyledPanelBuilder.createAlertPanel(
    "✗ Payment processing failed. Please try again.",
    "error"
);

// Warning alert
JPanel warningAlert = StyledPanelBuilder.createAlertPanel(
    "⚠ 5 members have pending payments",
    "warning"
);

// Info alert
JPanel infoAlert = StyledPanelBuilder.createAlertPanel(
    "ℹ System maintenance scheduled for tonight",
    "info"
);


/*
 * EXAMPLE 3: Creating Member Profile Cards
 * =========================================
 */

JPanel memberCard = StyledPanelBuilder.createMemberCard(
    "MEM-00156",        // Member ID
    "John Doe",         // Name
    "Premium Plan",     // Plan
    "Active"            // Status
);


/*
 * EXAMPLE 4: Creating HTML Tables with Styling
 * =============================================
 */

String[][] memberStats = {
    {"Member ID", "Name", "Plan", "Status"},
    {"MEM-00001", "Alice Johnson", "Premium", "Active"},
    {"MEM-00002", "Bob Smith", "VIP", "Active"},
    {"MEM-00003", "Carol White", "Student", "Inactive"}
};

String statsTableHTML = StyledPanelBuilder.generateStatsTableHTML(memberStats);
JEditorPane table = StyledPanelBuilder.createStyledHTMLPane(statsTableHTML);


// ============================================================================
// PART 2: MONGODB INTEGRATION
// ============================================================================

/*
 * EXAMPLE 5: MongoDB Connection and Basic Operations
 * ==================================================
 */

// Get MongoDB connection instance (singleton pattern)
MongoDBConnection mongoDb = MongoDBConnection.getInstance();

// Save a member to MongoDB
Member newMember = new Member(
    "MEM-00157",
    "David Chen",
    "555-9876",
    30,
    LocalDate.now(),
    MemberStatus.ACTIVE,
    "Premium",
    PlanDuration.MONTHLY,
    MemberType.CORPORATE
);

// Create BSON document
Document memberDoc = new Document()
    .append("_id", newMember.getMemberId())
    .append("fullName", newMember.getFullName())
    .append("contact", newMember.getContact())
    .append("age", newMember.getAge())
    .append("joiningDate", newMember.getJoiningDate().toString())
    .append("status", newMember.getStatus().toString())
    .append("planName", newMember.getPlanName())
    .append("planDuration", newMember.getPlanDuration().toString())
    .append("memberType", newMember.getMemberType().toString())
    .append("timestamp", System.currentTimeMillis());

// Insert to MongoDB
mongoDb.insertDocument("members", memberDoc);


/*
 * EXAMPLE 6: Retrieving Data from MongoDB
 * =======================================
 */

// Get all members from MongoDB
MongoCollection<Document> membersCollection = mongoDb.getCollection("members");
List<Document> allMembers = new ArrayList<>();
membersCollection.find().into(allMembers);

// Print all members
for (Document member : allMembers) {
    System.out.println("Member: " + member.getString("fullName"));
    System.out.println("Plan: " + member.getString("planName"));
    System.out.println("Status: " + member.getString("status"));
    System.out.println("---");
}


/*
 * EXAMPLE 7: Saving Payments to MongoDB
 * ====================================
 */

// Create and save a payment record
Payment payment = new Payment(
    "PAY-1001",
    "MEM-00157",
    60.00,
    LocalDateTime.now(),
    PaymentStatus.PAID
);

Document paymentDoc = new Document()
    .append("_id", payment.getPaymentId())
    .append("memberId", payment.getMemberId())
    .append("amount", payment.getAmount())
    .append("timestamp", payment.getTimestamp().toString())
    .append("status", payment.getStatus().toString())
    .append("receiptNote", payment.getReceiptNote())
    .append("databaseTimestamp", System.currentTimeMillis());

mongoDb.insertDocument("payments", paymentDoc);


/*
 * EXAMPLE 8: Updating Records in MongoDB
 * ======================================
 */

// Update a member's status
Document updateData = new Document("status", "INACTIVE");
mongoDb.updateDocument("members", "MEM-00157", updateData);


/*
 * EXAMPLE 9: Finding Specific Records
 * ===================================
 */

// Find a specific member by ID
Document member = mongoDb.findDocumentById("members", "MEM-00157");
if (member != null) {
    System.out.println("Found member: " + member.getString("fullName"));
}


/*
 * EXAMPLE 10: Deleting Records from MongoDB
 * ========================================
 */

// Delete a member record
mongoDb.deleteDocument("members", "MEM-00157");


// ============================================================================
// PART 3: INTEGRATION IN MAINFRAME
// ============================================================================

/*
 * EXAMPLE 11: Auto-Save to MongoDB on Member Addition
 * ==================================================
 *
 * In MainFrame.openMemberForm():
 */

// After adding member to GymManager
gymManager.addMember(newMember);

// Automatically save to MongoDB
saveMemberToMongoDB(newMember);

// Refresh UI with HTML/CSS components
refreshMembersTable();
refreshDashboard();


/*
 * EXAMPLE 12: Auto-Save Payments to MongoDB
 * =========================================
 *
 * In MainFrame.openPaymentForm():
 */

// Process payment in GymManager
Payment payment = gymManager.processPayment(memberId, amount, status);

// Automatically save to MongoDB
savePaymentToMongoDB(payment);

// Export invoice and refresh display
Path invoicePath = gymManager.exportInvoice(payment);
refreshPaymentsTable();
refreshDashboard();


/*
 * EXAMPLE 13: Loading Data from MongoDB on Startup
 * ===============================================
 *
 * In MainFrame.loadDataFromMongoDB():
 */

MongoDBConnection mongoDb = MongoDBConnection.getInstance();

// Load all members
List<Document> memberDocs = mongoDb.findAllDocuments("members");
System.out.println("✓ Loaded " + memberDocs.size() + " members from MongoDB");

// Load all payments
List<Document> paymentDocs = mongoDb.findAllDocuments("payments");
System.out.println("✓ Loaded " + paymentDocs.size() + " payments from MongoDB");


// ============================================================================
// PART 4: ADVANCED STYLING EXAMPLES
// ============================================================================

/*
 * EXAMPLE 14: Creating Dashboard HTML
 * ===================================
 */

String dashboardHTML = StyledUIComponent.createDashboardHTML();
JEditorPane dashboard = new JEditorPane();
dashboard.setContentType("text/html");
dashboard.setText(dashboardHTML);


/*
 * EXAMPLE 15: Creating Styled Stats HTML
 * ======================================
 */

String statsHTML = StyledUIComponent.createStatsHTML(
    "156",           // total members
    "142",           // active members
    "12450.50",      // monthly revenue
    "23"             // pending payments
);

JEditorPane statsPane = new JEditorPane();
statsPane.setContentType("text/html");
statsPane.setText(statsHTML);


/*
 * EXAMPLE 16: Creating Member Card HTML
 * ====================================
 */

String memberCardHTML = StyledUIComponent.createMemberCardHTML(
    "John Doe",
    "Premium Plan",
    "Active",
    "john.doe@email.com"
);

JEditorPane memberCardPane = new JEditorPane();
memberCardPane.setContentType("text/html");
memberCardPane.setText(memberCardHTML);


// ============================================================================
// PART 5: DATABASE QUERIES EXAMPLES
// ============================================================================

/*
 * EXAMPLE 17: Finding Active Members
 * ==================================
 */

MongoCollection<Document> members = mongoDb.getCollection("members");

List<Document> activeMembers = new ArrayList<>();
members.find(Filters.eq("status", "ACTIVE")).into(activeMembers);

System.out.println("Active members: " + activeMembers.size());


/*
 * EXAMPLE 18: Calculating Total Revenue from MongoDB
 * ==================================================
 */

MongoCollection<Document> payments = mongoDb.getCollection("payments");

double totalRevenue = 0;
for (Document payment : payments.find()) {
    totalRevenue += payment.getDouble("amount");
}

System.out.println("Total Revenue: $" + String.format("%.2f", totalRevenue));


/*
 * EXAMPLE 19: Finding Pending Payments
 * ===================================
 */

List<Document> pendingPayments = new ArrayList<>();
payments.find(Filters.eq("status", "PENDING")).into(pendingPayments);

System.out.println("Pending payments: " + pendingPayments.size());


// ============================================================================
// COMPILATION AND EXECUTION
// ============================================================================

/*
 * COMPILE:
 * javac -cp "lib/*:src" -d out src/ironpulse/**\/*.java
 *
 * RUN:
 * java -cp "lib/*:out" ironpulse.Main
 *
 * REQUIREMENTS:
 * - MongoDB running on localhost:27017
 * - JDK 11 or higher
 * - All JAR files in lib/ directory
 */


// ============================================================================
// KEY CLASSES AND METHODS
// ============================================================================

/**
 * StyledUIComponent - HTML/CSS styling
 * - createStyledEditorPane()
 * - createDashboardHTML()
 * - createStatsHTML()
 * - createMemberCardHTML()
 * - createAlertHTML()
 */

/**
 * StyledPanelBuilder - Swing component styling
 * - createStatCard()
 * - createAlertPanel()
 * - createMemberCard()
 * - createStyledHTMLPane()
 * - generateDashboardHTML()
 * - generateStatsTableHTML()
 */

/**
 * MongoDBConnection - Database operations
 * - getInstance() [Singleton]
 * - getDatabase()
 * - getCollection()
 * - insertDocument()
 * - findDocumentById()
 * - findAllDocuments()
 * - updateDocument()
 * - deleteDocument()
 * - close()
 */

/**
 * MainFrame - UI with MongoDB integration
 * - initializeMongoDBConnection()
 * - saveMemberToMongoDB()
 * - savePaymentToMongoDB()
 * - loadDataFromMongoDB()
 */
