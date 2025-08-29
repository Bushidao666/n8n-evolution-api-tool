#!/bin/bash

# Evolution API Tool - Installation Test Script
# Tests the published package installation

set -e

echo "🧪 Evolution API Tool - Installation Test"
echo "======================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Get package name from package.json
PACKAGE_NAME=$(node -e "console.log(require('./package.json').name)")
print_warning "Testing package: $PACKAGE_NAME"

# Create temporary directory
TEST_DIR="/tmp/n8n-evolution-test-$(date +%s)"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

print_status "Created test directory: $TEST_DIR"

# Initialize test project
print_status "Initializing test project..."
npm init -y > /dev/null

# Install our package
print_status "Installing $PACKAGE_NAME..."
npm install "$PACKAGE_NAME"

# Check if package was installed
if [ -d "node_modules/$PACKAGE_NAME" ]; then
    print_success "Package installed successfully"
else
    echo "❌ Package installation failed"
    exit 1
fi

# Check package contents
print_status "Checking package contents..."

REQUIRED_FILES=(
    "node_modules/$PACKAGE_NAME/package.json"
    "node_modules/$PACKAGE_NAME/index.js"
    "node_modules/$PACKAGE_NAME/dist"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -e "$file" ]; then
        print_success "✅ Found: $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

# Check dist contents
print_status "Checking dist directory contents..."
if [ -d "node_modules/$PACKAGE_NAME/dist/nodes" ] && [ -d "node_modules/$PACKAGE_NAME/dist/credentials" ]; then
    print_success "✅ dist/nodes and dist/credentials found"
else
    echo "❌ Missing dist subdirectories"
    exit 1
fi

# Check n8n configuration
print_status "Checking n8n configuration..."
N8N_CONFIG=$(node -e "console.log(JSON.stringify(require('./node_modules/$PACKAGE_NAME/package.json').n8n, null, 2))")
echo "n8n config:"
echo "$N8N_CONFIG"

# Verify keyword
HAS_KEYWORD=$(node -e "console.log(require('./node_modules/$PACKAGE_NAME/package.json').keywords.includes('n8n-community-node-package'))")
if [ "$HAS_KEYWORD" = "true" ]; then
    print_success "✅ Has n8n-community-node-package keyword"
else
    echo "❌ Missing n8n-community-node-package keyword"
    exit 1
fi

# Check SVG files
print_status "Checking SVG files..."
SVG_COUNT=$(find "node_modules/$PACKAGE_NAME/dist" -name "*.svg" | wc -l)
if [ "$SVG_COUNT" -gt 0 ]; then
    print_success "✅ Found $SVG_COUNT SVG files"
else
    echo "❌ No SVG files found"
    exit 1
fi

# Test requiring the package
print_status "Testing package require..."
node -e "require('$PACKAGE_NAME')" && print_success "✅ Package can be required" || echo "❌ Package require failed"

# Cleanup
print_status "Cleaning up test directory..."
cd /tmp
rm -rf "$TEST_DIR"

print_success "🎉 All installation tests passed!"
echo ""
echo "Package $PACKAGE_NAME is ready for use with n8n!"
echo ""
echo "Installation command for users:"
echo "  npm install $PACKAGE_NAME"
echo ""
echo "Or for n8n custom nodes:"
echo "  cd ~/.n8n/custom"
echo "  npm install $PACKAGE_NAME"
