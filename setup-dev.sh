#!/bin/bash

echo " IronPulse Local Development Setup"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
echo " Checking prerequisites..."

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED} Java not found${NC}"
    echo "Install Java 21: https://www.oracle.com/java/technologies/downloads/"
    exit 1
fi
JAVA_VERSION=$(java -version 2>&1 | grep -oP '(?<=version ").*?(?=")' | head -1)
echo -e "${GREEN} Java ${JAVA_VERSION} found${NC}"

# Check Maven (optional, for Spring Boot build)
if command -v mvn &> /dev/null; then
    MAVEN_VERSION=$(mvn -v 2>&1 | grep -oP '(?<=Apache Maven ).*?(?= )')
    echo -e "${GREEN} Maven ${MAVEN_VERSION} found${NC}"
else
    echo -e "${YELLOW}️  Maven not found (optional for development)${NC}"
fi

# Check Git
if ! command -v git &> /dev/null; then
    echo -e "${RED} Git not found${NC}"
    exit 1
fi
echo -e "${GREEN} Git found${NC}"

echo ""
echo " Setting up project structure..."

# Create necessary directories
mkdir -p src/main/java/com/ironpulse/{model,repository,service,controller,config}
mkdir -p src/main/resources
mkdir -p src/test/java/com/ironpulse
mkdir -p lib
mkdir -p out
mkdir -p dist

echo -e "${GREEN} Directory structure created${NC}"

echo ""
echo "️ Setting up environment configuration..."

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    echo -e "${YELLOW}️  Update .env file with your MongoDB Atlas credentials${NC}"
    echo "   Run: nano .env  (or your preferred editor)"
else
    echo -e "${GREEN} .env file already exists${NC}"
fi

echo ""
echo " Downloading dependencies..."

# Check if lib directory has required JARs
if [ ! -f "lib/mongodb-driver-sync-5.1.4.jar" ]; then
    echo "Downloading MongoDB driver..."
    bash scripts/fetch_mongo_driver.sh 2>/dev/null || {
        echo -e "${YELLOW}️  Could not auto-download MongoDB driver${NC}"
        echo "   Ensure lib/mongodb-driver-sync-5.1.4.jar exists"
    }
fi

if [ ! -f "lib/javafx-controls-21.0.5-linux.jar" ]; then
    echo "Downloading JavaFX libraries..."
    bash scripts/fetch_javafx.sh 2>/dev/null || {
        echo -e "${YELLOW}️  Could not auto-download JavaFX${NC}"
    }
fi

echo -e "${GREEN} Dependencies check complete${NC}"

echo ""
echo " Verifying MongoDB Atlas connection setup..."
echo ""
echo "To test MongoDB connection locally:"
echo "1. Ensure .env has MONGO_URI set correctly"
echo "2. Run: java -cp 'lib/*:out' com.ironpulse.MongoTest"
echo ""

echo ""
echo "️ Building project options:"
echo ""
echo "Option 1: Build with Maven (Spring Boot)"
echo "  $ mvn clean package"
echo ""
echo "Option 2: Build desktop JAR"
echo "  $ bash build.sh"
echo ""
echo "Option 3: Build Render-optimized"
echo "  $ bash build-render.sh"
echo ""

echo ""
echo " Running options:"
echo ""
echo "Option 1: Run Spring Boot API locally"
echo "  $ mvn spring-boot:run"
echo "  # API will be at http://localhost:8080/api"
echo ""
echo "Option 2: Run desktop version"
echo "  $ java -cp 'lib/*:out' ironpulse.Main"
echo ""

echo ""
echo " Testing options:"
echo ""
echo "Test API endpoints (after starting server):"
echo "  $ curl http://localhost:8080/api/members"
echo "  $ curl http://localhost:8080/api/dashboard/overview"
echo ""

echo ""
echo " Git workflow:"
echo ""
echo "Main branches:"
echo "  • main              - Development branch"
echo "  • production        - Production-ready"
echo "  • render-deployment - REST API for Render"
echo ""
echo "Check status:"
echo "  $ git branch -a"
echo "  $ git log --oneline -5"
echo ""

echo ""
echo " Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with MongoDB Atlas credentials"
echo "2. Build the project using one of the options above"
echo "3. Run tests to verify setup"
echo "4. Commit changes to appropriate branch"
echo ""
