#!/bin/bash

# Seed Demo Data for IronPulse Render Deployment
# This script populates the Render server with demo member and payment data
# Usage: ./seed-demo-data.sh <RENDER_URL>
# Example: ./seed-demo-data.sh https://ironpulse.onrender.com

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if URL is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Render URL not provided${NC}"
    echo "Usage: $0 <RENDER_URL>"
    echo "Example: $0 https://ironpulse.onrender.com"
    exit 1
fi

RENDER_URL="$1"
RENDER_URL="${RENDER_URL%/}"  # Remove trailing slash if present

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}IronPulse Demo Data Seeder${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}Target URL: ${RENDER_URL}${NC}"
echo ""

# Function to check API connectivity
check_api() {
    echo -e "${YELLOW}Checking API connectivity...${NC}"
    if curl -s -o /dev/null -w "%{http_code}" "$RENDER_URL/" | grep -q "200\|301\|302"; then
        echo -e "${GREEN}✓ API is reachable${NC}"
        return 0
    else
        echo -e "${RED}✗ Cannot reach API at $RENDER_URL${NC}"
        echo "Please verify the URL and ensure the Render service is running."
        exit 1
    fi
}

# Function to clear existing data
clear_database() {
    echo -e "${YELLOW}Clearing existing data...${NC}"
    
    # Get all member IDs and delete each one
    members=$(curl -s "$RENDER_URL/api/members" | jq -r '.[].id // empty' 2>/dev/null)
    if [ ! -z "$members" ]; then
        count=0
        while IFS= read -r id; do
            if [ ! -z "$id" ]; then
                curl -s -X DELETE "$RENDER_URL/api/members/$id" > /dev/null 2>&1
                ((count++))
            fi
        done <<< "$members"
        echo -e "${GREEN}✓ Deleted $count member(s)${NC}"
    fi
    
    # Get all payment IDs and delete each one
    payments=$(curl -s "$RENDER_URL/api/payments" | jq -r '.[].id // empty' 2>/dev/null)
    if [ ! -z "$payments" ]; then
        count=0
        while IFS= read -r id; do
            if [ ! -z "$id" ]; then
                curl -s -X DELETE "$RENDER_URL/api/payments/$id" > /dev/null 2>&1
                ((count++))
            fi
        done <<< "$payments"
        echo -e "${GREEN}✓ Deleted $count payment(s)${NC}"
    fi
}
# Function to seed members
seed_members() {
    echo -e "${YELLOW}Seeding member records...${NC}"
    
    local members=(
           '{"name":"Rajesh Kumar","email":"rajesh.k@example.com","phone":"9876543210","joinDate":"2024-01-15","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Priya Singh","email":"priya.singh@example.com","phone":"9876543211","joinDate":"2024-02-10","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Amit Patel","email":"amit.p@example.com","phone":"9876543212","joinDate":"2024-01-20","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Neha Sharma","email":"neha.s@example.com","phone":"9876543213","joinDate":"2024-03-05","membershipPlan":"Basic","status":"ACTIVE"}'
           '{"name":"Vikram Reddy","email":"vikram.r@example.com","phone":"9876543214","joinDate":"2024-02-28","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Aisha Khan","email":"aisha.k@example.com","phone":"9876543215","joinDate":"2024-03-12","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Rohan Gupta","email":"rohan.g@example.com","phone":"9876543216","joinDate":"2024-01-08","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Divya Nair","email":"divya.n@example.com","phone":"9876543217","joinDate":"2024-02-14","membershipPlan":"Basic","status":"INACTIVE"}'
           '{"name":"Arjun Verma","email":"arjun.v@example.com","phone":"9876543218","joinDate":"2024-03-20","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Kavya Menon","email":"kavya.m@example.com","phone":"9876543219","joinDate":"2024-01-25","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Sanjay Chopra","email":"sanjay.c@example.com","phone":"9876543220","joinDate":"2024-02-11","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Pooja Malhotra","email":"pooja.m@example.com","phone":"9876543221","joinDate":"2024-03-01","membershipPlan":"Basic","status":"ACTIVE"}'
           '{"name":"Harsh Desai","email":"harsh.d@example.com","phone":"9876543222","joinDate":"2024-01-30","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Sneha Iyer","email":"sneha.i@example.com","phone":"9876543223","joinDate":"2024-02-20","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Nikhil Bhat","email":"nikhil.b@example.com","phone":"9876543224","joinDate":"2024-03-08","membershipPlan":"Basic","status":"INACTIVE"}'
           '{"name":"Ananya Roy","email":"ananya.r@example.com","phone":"9876543225","joinDate":"2024-01-12","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Varun Sinha","email":"varun.s@example.com","phone":"9876543226","joinDate":"2024-02-17","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Ritika Jain","email":"ritika.j@example.com","phone":"9876543227","joinDate":"2024-03-03","membershipPlan":"Basic","status":"ACTIVE"}'
           '{"name":"Abhishek Singh","email":"abhishek.s@example.com","phone":"9876543228","joinDate":"2024-01-19","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Meera Kapoor","email":"meera.k@example.com","phone":"9876543229","joinDate":"2024-02-22","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Ravi Tiwari","email":"ravi.t@example.com","phone":"9876543230","joinDate":"2024-03-10","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Isha Bansal","email":"isha.b@example.com","phone":"9876543231","joinDate":"2024-01-28","membershipPlan":"Basic","status":"ACTIVE"}'
           '{"name":"Karan Kapadia","email":"karan.k@example.com","phone":"9876543232","joinDate":"2024-02-05","membershipPlan":"Standard","status":"ACTIVE"}'
           '{"name":"Nisha Saxena","email":"nisha.x@example.com","phone":"9876543233","joinDate":"2024-03-15","membershipPlan":"Premium","status":"ACTIVE"}'
           '{"name":"Ashish Mishra","email":"ashish.m@example.com","phone":"9876543234","joinDate":"2024-01-22","membershipPlan":"Basic","status":"INACTIVE"}'
    )
    
    local count=0
    for member in "${members[@]}"; do
        response=$(curl -s -w "\n%{http_code}" -X POST "$RENDER_URL/api/members" \
            -H "Content-Type: application/json" \
            -d "$member" 2>/dev/null)
        http_code=$(echo "$response" | tail -n 1)
        
        if [[ "$http_code" == "201" ]] || [[ "$http_code" == "200" ]]; then
            ((count++))
            echo -ne "\r${GREEN}✓${NC} Seeded $count member(s)   "
        fi
    done
    echo ""
    echo -e "${GREEN}✓ Successfully seeded $count members${NC}"
}

# Function to seed payments
seed_payments() {
    echo -e "${YELLOW}Seeding payment records...${NC}"
    
    local payments=(
           '{"memberId":"1","amount":5000,"paymentDate":"2024-03-10T10:30:00","status":"PAID"}'
           '{"memberId":"2","amount":3000,"paymentDate":"2024-03-09T11:15:00","status":"PAID"}'
           '{"memberId":"3","amount":5000,"paymentDate":"2024-03-11T09:45:00","status":"PAID"}'
           '{"memberId":"4","amount":2000,"paymentDate":"2024-03-08T14:20:00","status":"PAID"}'
           '{"memberId":"5","amount":5000,"paymentDate":"2024-03-14T16:00:00","status":"PENDING"}'
           '{"memberId":"6","amount":3000,"paymentDate":"2024-03-10T10:00:00","status":"PAID"}'
           '{"memberId":"7","amount":5000,"paymentDate":"2024-03-12T12:30:00","status":"PAID"}'
           '{"memberId":"8","amount":2000,"paymentDate":"2024-03-07T08:15:00","status":"PAID"}'
           '{"memberId":"9","amount":3000,"paymentDate":"2024-03-13T15:45:00","status":"PAID"}'
           '{"memberId":"10","amount":5000,"paymentDate":"2024-03-10T11:00:00","status":"PAID"}'
           '{"memberId":"11","amount":3000,"paymentDate":"2024-03-01T10:30:00","status":"PAID"}'
           '{"memberId":"12","amount":2000,"paymentDate":"2024-03-15T13:20:00","status":"PENDING"}'
           '{"memberId":"13","amount":5000,"paymentDate":"2024-03-10T09:00:00","status":"PAID"}'
           '{"memberId":"14","amount":3000,"paymentDate":"2024-03-12T14:15:00","status":"PAID"}'
           '{"memberId":"15","amount":2000,"paymentDate":"2024-03-09T16:30:00","status":"PAID"}'
           '{"memberId":"16","amount":5000,"paymentDate":"2024-03-11T10:45:00","status":"PAID"}'
           '{"memberId":"17","amount":3000,"paymentDate":"2024-03-10T12:00:00","status":"PAID"}'
           '{"memberId":"18","amount":2000,"paymentDate":"2024-03-14T15:30:00","status":"PAID"}'
           '{"memberId":"19","amount":5000,"paymentDate":"2024-03-15T11:15:00","status":"PENDING"}'
           '{"memberId":"20","amount":3000,"paymentDate":"2024-03-10T13:45:00","status":"PAID"}'
    )
    
    local count=0
    for payment in "${payments[@]}"; do
        response=$(curl -s -w "\n%{http_code}" -X POST "$RENDER_URL/api/payments" \
            -H "Content-Type: application/json" \
            -d "$payment" 2>/dev/null)
        http_code=$(echo "$response" | tail -n 1)
        
        if [[ "$http_code" == "201" ]] || [[ "$http_code" == "200" ]]; then
            ((count++))
            echo -ne "\r${GREEN}✓${NC} Seeded $count payment(s)   "
        fi
    done
    echo ""
    echo -e "${GREEN}✓ Successfully seeded $count payments${NC}"
}

# Main execution
echo ""
check_api
echo ""
clear_database
echo ""
seed_members
echo ""
seed_payments
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Demo data seeding completed successfully!${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Open ${BLUE}${RENDER_URL}${NC} in your browser"
echo -e "2. Login with credentials: admin / admin123"
echo -e "3. View the seeded demo data in Dashboard, Members, and Payments sections"
echo ""
