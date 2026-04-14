#!/bin/bash

# Seed Demo Data for IronPulse Render Deployment
# This script populates the Render server with demo member and payment data
# Usage: ./seed-demo-data.sh <RENDER_URL>
# Example: ./seed-demo-data.sh https://ironpulse.onrender.com

set -e

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
    if curl -s -f "$RENDER_URL/api/health" > /dev/null 2>&1 || curl -s -f "$RENDER_URL/" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ API is reachable${NC}"
        return 0
    else
        echo -e "${RED}✗ Cannot reach API at $RENDER_URL${NC}"
        echo "Please verify the URL and ensure the Render service is running."
        exit 1
    fi
}

# Function to seed members
seed_members() {
    echo -e "${YELLOW}Seeding member records...${NC}"
    
    local members=(
        '{"name":"Rajesh Kumar","email":"rajesh.k@example.com","phone":"9876543210","joinDate":"2024-01-15","membershipType":"Premium"}'
        '{"name":"Priya Singh","email":"priya.singh@example.com","phone":"9876543211","joinDate":"2024-02-10","membershipType":"Standard"}'
        '{"name":"Amit Patel","email":"amit.p@example.com","phone":"9876543212","joinDate":"2024-01-20","membershipType":"Premium"}'
        '{"name":"Neha Sharma","email":"neha.s@example.com","phone":"9876543213","joinDate":"2024-03-05","membershipType":"Basic"}'
        '{"name":"Vikram Reddy","email":"vikram.r@example.com","phone":"9876543214","joinDate":"2024-02-28","membershipType":"Premium"}'
        '{"name":"Aisha Khan","email":"aisha.k@example.com","phone":"9876543215","joinDate":"2024-03-12","membershipType":"Standard"}'
        '{"name":"Rohan Gupta","email":"rohan.g@example.com","phone":"9876543216","joinDate":"2024-01-08","membershipType":"Premium"}'
        '{"name":"Divya Nair","email":"divya.n@example.com","phone":"9876543217","joinDate":"2024-02-14","membershipType":"Basic"}'
        '{"name":"Arjun Verma","email":"arjun.v@example.com","phone":"9876543218","joinDate":"2024-03-20","membershipType":"Standard"}'
        '{"name":"Kavya Menon","email":"kavya.m@example.com","phone":"9876543219","joinDate":"2024-01-25","membershipType":"Premium"}'
        '{"name":"Sanjay Chopra","email":"sanjay.c@example.com","phone":"9876543220","joinDate":"2024-02-11","membershipType":"Standard"}'
        '{"name":"Pooja Malhotra","email":"pooja.m@example.com","phone":"9876543221","joinDate":"2024-03-01","membershipType":"Basic"}'
        '{"name":"Harsh Desai","email":"harsh.d@example.com","phone":"9876543222","joinDate":"2024-01-30","membershipType":"Premium"}'
        '{"name":"Sneha Iyer","email":"sneha.i@example.com","phone":"9876543223","joinDate":"2024-02-20","membershipType":"Standard"}'
        '{"name":"Nikhil Bhat","email":"nikhil.b@example.com","phone":"9876543224","joinDate":"2024-03-08","membershipType":"Basic"}'
        '{"name":"Ananya Roy","email":"ananya.r@example.com","phone":"9876543225","joinDate":"2024-01-12","membershipType":"Premium"}'
        '{"name":"Varun Sinha","email":"varun.s@example.com","phone":"9876543226","joinDate":"2024-02-17","membershipType":"Standard"}"}'
        '{"name":"Ritika Jain","email":"ritika.j@example.com","phone":"9876543227","joinDate":"2024-03-03","membershipType":"Basic"}'
        '{"name":"Abhishek Singh","email":"abhishek.s@example.com","phone":"9876543228","joinDate":"2024-01-19","membershipType":"Premium"}'
        '{"name":"Meera Kapoor","email":"meera.k@example.com","phone":"9876543229","joinDate":"2024-02-22","membershipType":"Standard"}'
        '{"name":"Ravi Tiwari","email":"ravi.t@example.com","phone":"9876543230","joinDate":"2024-03-10","membershipType":"Premium"}'
        '{"name":"Isha Bansal","email":"isha.b@example.com","phone":"9876543231","joinDate":"2024-01-28","membershipType":"Basic"}'
        '{"name":"Karan Kapadia","email":"karan.k@example.com","phone":"9876543232","joinDate":"2024-02-05","membershipType":"Standard"}'
        '{"name":"Nisha Saxena","email":"nisha.x@example.com","phone":"9876543233","joinDate":"2024-03-15","membershipType":"Premium"}'
        '{"name":"Ashish Mishra","email":"ashish.m@example.com","phone":"9876543234","joinDate":"2024-01-22","membershipType":"Basic"}'
    )
    
    local count=0
    for member in "${members[@]}"; do
        if curl -s -X POST "$RENDER_URL/api/members" \
            -H "Content-Type: application/json" \
            -d "$member" > /dev/null 2>&1; then
            ((count++))
            echo -ne "\r${GREEN}✓${NC} Seeded $count member(s)"
        fi
    done
    echo ""
    echo -e "${GREEN}✓ Successfully seeded $count members${NC}"
}

# Function to seed payments
seed_payments() {
    echo -e "${YELLOW}Seeding payment records...${NC}"
    
    local payments=(
        '{"memberId":"1","amount":5000,"type":"Monthly","status":"Completed","date":"2024-03-10"}'
        '{"memberId":"2","amount":3000,"type":"Monthly","status":"Completed","date":"2024-03-09"}'
        '{"memberId":"3","amount":5000,"type":"Monthly","status":"Completed","date":"2024-03-11"}'
        '{"memberId":"4","amount":2000,"type":"Monthly","status":"Completed","date":"2024-03-08"}'
        '{"memberId":"5","amount":5000,"type":"Monthly","status":"Pending","date":"2024-03-14"}'
        '{"memberId":"6","amount":3000,"type":"Monthly","status":"Completed","date":"2024-03-10"}'
        '{"memberId":"7","amount":5000,"type":"Monthly","status":"Completed","date":"2024-03-12"}'
        '{"memberId":"8","amount":2000,"type":"Monthly","status":"Completed","date":"2024-03-07"}'
        '{"memberId":"9","amount":3000,"type":"Monthly","status":"Completed","date":"2024-03-13"}'
        '{"memberId":"10","amount":5000,"type":"Monthly","status":"Completed","date":"2024-03-10"}'
        '{"memberId":"11","amount":3000,"type":"Quarterly","status":"Completed","date":"2024-03-01"}'
        '{"memberId":"12","amount":2000,"type":"Monthly","status":"Pending","date":"2024-03-15"}'
        '{"memberId":"13","amount":5000,"type":"Monthly","status":"Completed","date":"2024-03-10"}'
        '{"memberId":"14","amount":3000,"type":"Monthly","status":"Completed","date":"2024-03-12"}'
        '{"memberId":"15","amount":2000,"type":"Monthly","status":"Completed","date":"2024-03-09"}'
        '{"memberId":"16","amount":5000,"type":"Monthly","status":"Completed","date":"2024-03-11"}'
        '{"memberId":"17","amount":3000,"type":"Monthly","status":"Completed","date":"2024-03-10"}'
        '{"memberId":"18","amount":2000,"type":"Monthly","status":"Completed","date":"2024-03-14"}'
        '{"memberId":"19","amount":5000,"type":"Monthly","status":"Pending","date":"2024-03-15"}'
        '{"memberId":"20","amount":3000,"type":"Monthly","status":"Completed","date":"2024-03-10"}'
    )
    
    local count=0
    for payment in "${payments[@]}"; do
        if curl -s -X POST "$RENDER_URL/api/payments" \
            -H "Content-Type: application/json" \
            -d "$payment" > /dev/null 2>&1; then
            ((count++))
            echo -ne "\r${GREEN}✓${NC} Seeded $count payment(s)"
        fi
    done
    echo ""
    echo -e "${GREEN}✓ Successfully seeded $count payments${NC}"
}

# Main execution
echo ""
check_api
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
