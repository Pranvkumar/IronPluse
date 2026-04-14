#!/bin/bash

echo "🧪 IronPulse Local Testing Suite"
echo "=================================="
echo ""

API_URL="${1:-http://localhost:8080/api}"

echo "Testing API at: $API_URL"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to test API endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    echo "Testing: $description"
    echo "  $method $endpoint"
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X $method "$API_URL$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X $method "$API_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data")
    fi
    
    http_code=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | sed '$d')
    
    if [[ $http_code == 200 ]] || [[ $http_code == 201 ]]; then
        echo -e "  ${GREEN}✅ Success (HTTP $http_code)${NC}"
        echo "  Response: $(echo $body | jq '.' 2>/dev/null || echo $body)"
    else
        echo -e "  ${RED}❌ Failed (HTTP $http_code)${NC}"
        echo "  Response: $(echo $body | jq '.' 2>/dev/null || echo $body)"
    fi
    echo ""
}

# Health check
echo "1️⃣ Health Check"
echo "==============="
test_endpoint "GET" "/dashboard/overview" "" "Dashboard Overview"

echo ""
echo "2️⃣ Member Tests"
echo "==============="

# Get all members
test_endpoint "GET" "/members" "" "Get All Members"

# Create a test member
test_member_data='{
  "name": "Test User",
  "email": "test@example.com",
  "phone": "9876543210",
  "age": 25,
  "membershipPlan": "Premium",
  "status": "ACTIVE"
}'

test_endpoint "POST" "/members" "$test_member_data" "Create New Member"

# Search members
test_endpoint "GET" "/members/search?query=Test" "" "Search Members"

# Get member stats
test_endpoint "GET" "/members/stats/summary" "" "Member Statistics"

echo ""
echo "3️⃣ Payment Tests"
echo "==============="

# Get all payments
test_endpoint "GET" "/payments" "" "Get All Payments"

# Create test payment
test_payment_data='{
  "memberId": "test-member-1",
  "amount": 500,
  "paymentDate": "2024-04-14T10:00:00",
  "status": "PAID",
  "paymentMethod": "CARD"
}'

test_endpoint "POST" "/payments" "$test_payment_data" "Record Payment"

# Get payment stats
test_endpoint "GET" "/payments/stats/revenue" "" "Revenue Statistics"

echo ""
echo "4️⃣ Dashboard Tests"
echo "=================="

test_endpoint "GET" "/dashboard/overview" "" "Dashboard Overview"
test_endpoint "GET" "/dashboard/revenue" "" "Revenue Data"
test_endpoint "GET" "/dashboard/members/distribution" "" "Member Distribution"
test_endpoint "GET" "/dashboard/activities/recent" "" "Recent Activities"

echo ""
echo "✅ Testing complete!"
echo ""
echo "📊 Summary:"
echo "  • If all tests show ${GREEN}✅${NC}, your API is working correctly"
echo "  • If any tests show ${RED}❌${NC}, check:"
echo "    - Server is running on $API_URL"
echo "    - MongoDB connection is active"
echo "    - Environment variables are set"
echo "    - Logs show any error messages"
echo ""
echo "💡 Next steps:"
echo "  • Deploy to Render using render.yaml"
echo "  • Connect frontend application"
echo "  • Set up monitoring and alerts"
echo ""
