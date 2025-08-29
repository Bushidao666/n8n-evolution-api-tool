#!/bin/bash

# Evolution API Tool - Publication Script
# This script automates the npm publication process

set -e

echo "🚀 Evolution API Tool - Publication Process"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

# Check if user is logged in to npm
if ! npm whoami &> /dev/null; then
    print_warning "You are not logged in to npm."
    echo "Please run: npm login"
    exit 1
fi

print_success "npm login verified for user: $(npm whoami)"

# Check available package names
echo ""
print_status "Checking package name availability..."

PACKAGE_NAMES=(
    "n8n-nodes-evolution-api-ai-tool"
    "n8n-nodes-evolution-ai-agent-tool" 
    "n8n-evolution-ai-agent-tool"
    "n8n-evolution-api-ai-tool"
    "n8n-ai-evolution-tool"
)

AVAILABLE_NAMES=()

for name in "${PACKAGE_NAMES[@]}"; do
    if npm view "$name" version &> /dev/null; then
        print_warning "❌ $name - Already exists"
    else
        print_success "✅ $name - Available"
        AVAILABLE_NAMES+=("$name")
    fi
done

if [ ${#AVAILABLE_NAMES[@]} -eq 0 ]; then
    print_error "No package names available. Please choose a different name."
    exit 1
fi

echo ""
print_status "Available names found: ${#AVAILABLE_NAMES[@]}"
print_status "Recommended: ${AVAILABLE_NAMES[0]}"

# Ask user to select package name
echo ""
echo "Select package name:"
for i in "${!AVAILABLE_NAMES[@]}"; do
    echo "$((i+1)). ${AVAILABLE_NAMES[$i]}"
done

read -p "Enter choice (1-${#AVAILABLE_NAMES[@]}): " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#AVAILABLE_NAMES[@]} ]; then
    print_error "Invalid choice. Exiting."
    exit 1
fi

SELECTED_NAME="${AVAILABLE_NAMES[$((choice-1))]}"
print_success "Selected: $SELECTED_NAME"

# Update package.json with selected name
print_status "Updating package.json..."
node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.name = '$SELECTED_NAME';
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
"
print_success "package.json updated with name: $SELECTED_NAME"

# Install dependencies
print_status "Installing dependencies..."
npm ci

# Run linting
print_status "Running linting..."
npm run lint

# Build project
print_status "Building project..."
npm run build

# Test package creation
print_status "Testing package creation..."
npm pack --dry-run

# Show package contents
print_status "Package contents preview:"
npm pack
TARBALL=$(ls *.tgz | head -n1)
echo "Tarball: $TARBALL"
tar -tzf "$TARBALL" | head -20
echo "..."
rm "$TARBALL"

# Final confirmation
echo ""
print_warning "⚠️  Ready to publish $SELECTED_NAME"
echo "This will:"
echo "  1. Publish to npm registry"
echo "  2. Make package publicly available"
echo "  3. Create version 1.0.0"
echo ""
read -p "Continue with publication? (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    print_status "Publication cancelled by user."
    exit 0
fi

# Publish to npm
print_status "Publishing to npm..."
npm publish

# Verify publication
print_status "Verifying publication..."
sleep 5
npm view "$SELECTED_NAME" version

print_success "🎉 Successfully published $SELECTED_NAME v1.0.0!"
echo ""
echo "Next steps:"
echo "  1. Test installation: npm install $SELECTED_NAME"
echo "  2. Update README with correct package name"
echo "  3. Create GitHub release"
echo "  4. Announce to n8n community"
echo ""
echo "Package URL: https://www.npmjs.com/package/$SELECTED_NAME"
echo "GitHub URL: https://github.com/Bushidao666/n8n-evolution-api-tool"
