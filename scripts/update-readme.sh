#!/bin/bash

# Evolution API Tool - README Update Script
# Updates README with correct package name after publication

set -e

echo "📝 Evolution API Tool - README Update"
echo "==================================="

# Get package name from package.json
PACKAGE_NAME=$(node -e "console.log(require('./package.json').name)")
echo "Package name: $PACKAGE_NAME"

# Create backup
cp README.md README.md.backup
echo "✅ Created README backup"

# Update package name in README
sed -i.bak "s/n8n-nodes-evolution-api-tool/$PACKAGE_NAME/g" README.md
echo "✅ Updated package name in README"

# Update installation commands
sed -i.bak "s/npm install n8n-nodes-evolution-api-tool/npm install $PACKAGE_NAME/g" README.md
echo "✅ Updated installation commands"

# Clean up backup files
rm -f README.md.bak

# Show changes
echo ""
echo "📋 Changes made:"
echo "- Updated all references from 'n8n-nodes-evolution-api-tool' to '$PACKAGE_NAME'"
echo "- Updated npm install commands"
echo ""
echo "✅ README.md updated successfully!"
echo "💾 Backup saved as README.md.backup"

# Commit changes if git is available
if command -v git &> /dev/null; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo ""
        read -p "Commit changes to git? (y/N): " commit_changes
        if [[ $commit_changes =~ ^[Yy]$ ]]; then
            git add README.md
            git commit -m "docs: update README with published package name $PACKAGE_NAME"
            echo "✅ Changes committed to git"
        fi
    fi
fi
