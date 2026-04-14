#!/bin/bash

# ============================================================================
# IronPulse Pro - Build and Run Script
# ============================================================================
# This script compiles and runs the IronPulse Pro Gym Management System
# with MongoDB integration and HTML/CSS styling
# ============================================================================

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                    IronPulse Pro - Build & Run                       ║"
echo "║            Gym Management System with MongoDB Integration            ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if we're in the right directory
if [ ! -d "src/ironpulse" ]; then
    echo " Error: This script must be run from the IronPluse directory"
    echo "   Current directory: $(pwd)"
    echo "   Expected: IronPluse/"
    exit 1
fi

# Check Java installation
echo " Checking Java installation..."
if ! command -v java &> /dev/null; then
    echo " Error: Java is not installed or not in PATH"
    echo "   Please install Java JDK 11 or higher"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | grep -oP 'version "\K[0-9]+' | head -1)
if [ "$JAVA_VERSION" -lt 11 ]; then
    echo " Error: Java version must be 11 or higher (found: $JAVA_VERSION)"
    exit 1
fi
echo " Java version $JAVA_VERSION found"
echo ""

# Check MongoDB drivers
echo " Checking MongoDB drivers..."
if [ ! -d "lib" ] || [ -z "$(ls lib/*.jar 2>/dev/null)" ]; then
    echo " Error: MongoDB driver JARs not found in lib directory"
    echo "   Please ensure these files are present:"
    echo "   - lib/mongodb-driver-core-5.1.4.jar"
    echo "   - lib/mongodb-driver-sync-5.1.4.jar"
    echo "   - lib/bson-5.1.4.jar"
    exit 1
fi
echo " MongoDB drivers found"
echo ""

echo " Fetching required Java dependencies..."
bash scripts/fetch_mongo_driver.sh >/dev/null
bash scripts/fetch_javafx.sh >/dev/null
echo " MongoDB + JavaFX dependencies ready"
echo ""

# Clean previous build
echo " Cleaning previous build..."
if [ -d "out" ]; then
    rm -rf out
    echo " Cleaned out directory"
fi
if [ -d "dist" ]; then
    rm -rf dist
    echo " Cleaned dist directory"
fi
echo ""

# Create output directories
echo " Creating output directories..."
mkdir -p out
mkdir -p dist
echo " Output directories created"
echo ""

# Compile
echo "️  Compiling source files..."
echo "   Command: javac --module-path \"lib\" --add-modules javafx.controls,javafx.graphics -cp \"lib/*:src\" -d out src/**/*.java"
echo ""

if javac --module-path "lib" --add-modules javafx.controls,javafx.graphics -cp "lib/*:src" -d out $(find src -name "*.java") 2>&1; then
    mkdir -p out/ironpulse/fx
    cp src/ironpulse/fx/ironpulse-fx.css out/ironpulse/fx/ironpulse-fx.css

    jar --create --file dist/IronPulse.jar -C out .

    echo ""
    echo " Compilation successful!"
    echo " JAR created: dist/IronPulse.jar"

    # Count compiled classes
    CLASS_COUNT=$(find out -name "*.class" 2>/dev/null | wc -l)
    echo "   Compiled $CLASS_COUNT Java classes"
else
    echo ""
    echo " Compilation failed!"
    echo "   Please check the errors above"
    exit 1
fi
echo ""

# Check MongoDB
echo " Checking MongoDB connection..."
if command -v mongosh &> /dev/null; then
    if mongosh --eval "db.version()" &> /dev/null; then
        echo " MongoDB is running and accessible"
    else
        echo "️  MongoDB appears to be available but connection failed"
        echo "   You may need to start MongoDB manually:"
        echo ""
        echo "   macOS:  brew services start mongodb-community"
        echo "   Linux:  sudo systemctl start mongod"
        echo "   Docker: docker run -d -p 27017:27017 mongo:latest"
        echo ""
    fi
else
    echo "️  mongosh not found in PATH (optional for verification)"
    echo "   MongoDB should still work if running on localhost:27017"
fi
echo ""

# Ready to run
echo " Build complete and ready to run!"
echo ""
echo "════════════════════════════════════════════════════════════════════════"
echo ""

# Ask to run
if [ "$1" != "--build-only" ]; then
    echo "Would you like to run the application now? (y/n)"
    read -r response

    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        echo ""
        echo " Starting IronPulse Pro..."
        echo ""
        echo "⏳ Loading application..."
        echo ""
        java --module-path "lib" --add-modules javafx.controls,javafx.graphics -cp "lib/*:dist/IronPulse.jar" ironpulse.Main
    else
        echo ""
        echo " To run the application manually, use:"
        echo "   java --module-path \"lib\" --add-modules javafx.controls,javafx.graphics -cp \"lib/*:dist/IronPulse.jar\" ironpulse.Main"
        echo ""
    fi
else
    echo "Build completed successfully!"
    echo "To run the application manually, use:"
    echo "   java --module-path \"lib\" --add-modules javafx.controls,javafx.graphics -cp \"lib/*:dist/IronPulse.jar\" ironpulse.Main"
    echo ""
fi
