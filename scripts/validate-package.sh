#!/bin/bash

# Evolution API Tool - Package Validation Script
# Validates package before publication

set -e

echo "🔍 Evolution API Tool - Package Validation"
echo "========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

ERRORS=0
WARNINGS=0

# Function to increment error count
fail_check() {
    print_error "$1"
    ((ERRORS++))
}

# Function to increment warning count
warn_check() {
    print_warning "$1"
    ((WARNINGS++))
}

print_status "Validating package.json..."

# Check if package.json exists
if [ ! -f "package.json" ]; then
    fail_check "package.json not found"
    exit 1
fi

# Parse package.json
PKG_NAME=$(node -e "console.log(require('./package.json').name || '')")
PKG_VERSION=$(node -e "console.log(require('./package.json').version || '')")
PKG_KEYWORDS=$(node -e "console.log((require('./package.json').keywords || []).join(','))")
PKG_N8N=$(node -e "console.log(JSON.stringify(require('./package.json').n8n || {}))")

# Validate required fields
print_status "Checking required package.json fields..."

if [ -z "$PKG_NAME" ]; then
    fail_check "Package name is missing"
else
    print_success "✅ Name: $PKG_NAME"
fi

if [ -z "$PKG_VERSION" ]; then
    fail_check "Package version is missing"
else
    print_success "✅ Version: $PKG_VERSION"
fi

# Check for community node keyword
print_status "Checking n8n community node requirements..."

if [[ "$PKG_KEYWORDS" == *"n8n-community-node-package"* ]]; then
    print_success "✅ Has n8n-community-node-package keyword"
else
    fail_check "Missing required keyword: n8n-community-node-package"
fi

# Check n8n configuration
if [ "$PKG_N8N" != "{}" ]; then
    print_success "✅ Has n8n configuration"
    
    # Check nodes and credentials paths
    NODES_COUNT=$(node -e "console.log((require('./package.json').n8n.nodes || []).length)")
    CREDS_COUNT=$(node -e "console.log((require('./package.json').n8n.credentials || []).length)")
    
    if [ "$NODES_COUNT" -gt 0 ]; then
        print_success "✅ Has $NODES_COUNT node(s) configured"
    else
        fail_check "No nodes configured in n8n section"
    fi
    
    if [ "$CREDS_COUNT" -gt 0 ]; then
        print_success "✅ Has $CREDS_COUNT credential(s) configured"
    else
        warn_check "No credentials configured in n8n section"
    fi
else
    fail_check "Missing n8n configuration section"
fi

# Check required files
print_status "Checking required files..."

REQUIRED_FILES=(
    "package.json"
    "index.js"
    "README.md"
    "LICENSE"
    "tsconfig.json"
    "gulpfile.js"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "✅ Found: $file"
    else
        if [ "$file" = "LICENSE" ] || [ "$file" = "README.md" ]; then
            fail_check "Missing required file: $file"
        else
            warn_check "Missing recommended file: $file"
        fi
    fi
done

# Check source directories
print_status "Checking source directories..."

if [ -d "nodes" ]; then
    NODE_COUNT=$(find nodes -name "*.ts" | wc -l)
    print_success "✅ Found nodes/ directory with $NODE_COUNT TypeScript files"
else
    fail_check "Missing nodes/ directory"
fi

if [ -d "credentials" ]; then
    CRED_COUNT=$(find credentials -name "*.ts" | wc -l)
    print_success "✅ Found credentials/ directory with $CRED_COUNT TypeScript files"
else
    warn_check "Missing credentials/ directory"
fi

# Check build directory
print_status "Checking build output..."

if [ -d "dist" ]; then
    print_success "✅ Found dist/ directory"
    
    if [ -d "dist/nodes" ]; then
        DIST_NODES=$(find dist/nodes -name "*.js" | wc -l)
        print_success "✅ Found dist/nodes with $DIST_NODES JavaScript files"
    else
        fail_check "Missing dist/nodes directory"
    fi
    
    if [ -d "dist/credentials" ]; then
        DIST_CREDS=$(find dist/credentials -name "*.js" | wc -l)
        print_success "✅ Found dist/credentials with $DIST_CREDS JavaScript files"
    else
        warn_check "Missing dist/credentials directory"
    fi
else
    fail_check "Missing dist/ directory. Run 'npm run build' first."
fi

# Check SVG icons
print_status "Checking SVG icons..."

SVG_COUNT=$(find . -name "*.svg" | grep -v node_modules | wc -l)
if [ "$SVG_COUNT" -gt 0 ]; then
    print_success "✅ Found $SVG_COUNT SVG icon(s)"
else
    warn_check "No SVG icons found"
fi

# Test build process
print_status "Testing build process..."

if npm run build > /dev/null 2>&1; then
    print_success "✅ Build process successful"
else
    fail_check "Build process failed"
fi

# Test linting
print_status "Testing linting..."

if npm run lint > /dev/null 2>&1; then
    print_success "✅ Linting passed"
else
    warn_check "Linting failed or has warnings"
fi

# Test package creation
print_status "Testing package creation..."

if npm pack --dry-run > /dev/null 2>&1; then
    print_success "✅ Package creation successful"
else
    fail_check "Package creation failed"
fi

# Summary
echo ""
echo "📊 Validation Summary:"
echo "====================="

if [ $ERRORS -eq 0 ]; then
    print_success "✅ All critical checks passed!"
else
    print_error "❌ $ERRORS critical error(s) found"
fi

if [ $WARNINGS -gt 0 ]; then
    print_warning "⚠️  $WARNINGS warning(s) found"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "🚀 Package is ready for publication!"
    echo ""
    echo "Next steps:"
    echo "  1. Run: npm login"
    echo "  2. Run: ./scripts/publish.sh"
    echo "  3. Test: ./scripts/test-install.sh"
    exit 0
else
    echo "🔧 Please fix the errors before publishing."
    exit 1
fi
