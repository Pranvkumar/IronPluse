#!/bin/bash
set -e

echo "Building IronPulse API for Render..."

if ! command -v mvn &> /dev/null; then
    echo "Installing Maven..."
    apt-get update && apt-get install -y maven
fi

echo "Running Maven package..."
mvn -q clean package -DskipTests

echo "Build complete"
ls -lh target/ironpulse-api-2.0-render.jar
