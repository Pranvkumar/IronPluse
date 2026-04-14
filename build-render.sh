#!/bin/bash
set -e

echo "🏗️ Building IronPulse API for Render..."

# Install Maven if not already installed
if ! command -v mvn &> /dev/null; then
    echo "📦 Installing Maven..."
    apt-get update && apt-get install -y maven
fi

# Download JavaFX libraries if not present
if [ ! -f "lib/javafx-base-21.0.5.jar" ]; then
    echo "📥 Downloading JavaFX libraries..."
    bash scripts/fetch_javafx.sh
fi

# Download MongoDB driver if not present  
if [ ! -f "lib/mongodb-driver-sync-5.1.4.jar" ]; then
    echo "📥 Downloading MongoDB driver..."
    bash scripts/fetch_mongo_driver.sh
fi

# Compile Java files
echo "🔨 Compiling Java source files..."
mkdir -p out
javac --module-path "lib" --add-modules javafx.controls,javafx.graphics \
    -cp "lib/*" -d out $(find src -name "*.java" 2>/dev/null || echo "")

# Build JAR
echo "📦 Creating JAR file..."
mkdir -p dist

# Create manifest
cat > /tmp/manifest.txt << EOF
Manifest-Version: 1.0
Main-Class: ironpulse.Main
Class-Path: $(echo lib/*.jar | tr ' ' ':')
EOF

# Package JAR with dependencies
jar cmf /tmp/manifest.txt dist/IronPulse-API.jar -C out . \
    -C . src/ironpulse/resources/ 2>/dev/null || true

echo "✅ Build complete!"
echo "📦 JAR created at: dist/IronPulse-API.jar"
ls -lh dist/IronPulse-API.jar

echo "🎯 Ready for deployment!"
