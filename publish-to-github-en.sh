#!/bin/bash
# Karlsen v3.1.1 - GitHub Publish Script (English)
# This script automatically publishes rusty-karlsen to GitHub

set -e

echo "================================================"
echo "Karlsen v3.1.1 GitHub Publish Script"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get user input
echo -e "${YELLOW}GitHub Organization/Username:${NC}"
read -p "  (e.g., karlsencoin): " GITHUB_ORG
echo ""

echo -e "${YELLOW}GitHub Personal Access Token:${NC}"
echo "  (GitHub Settings → Developer settings → Personal access tokens)"
read -sp "  Token: " GITHUB_TOKEN
echo ""
echo ""

# Repository name
REPO_NAME="rusty-karlsen"
REPO_URL="https://${GITHUB_TOKEN}@github.com/${GITHUB_ORG}/${REPO_NAME}.git"

echo -e "${GREEN}[1/6]${NC} Preparing source code..."

# Extract source
if [ -f "karlsen-v3.1.1-patched-source.tar.gz" ]; then
    tar -xzf karlsen-v3.1.1-patched-source.tar.gz
    cd rusty-karlsen-3.1.0
else
    echo -e "${RED}ERROR:${NC} karlsen-v3.1.1-patched-source.tar.gz not found!"
    exit 1
fi

echo -e "${GREEN}[2/6]${NC} Initializing Git repository..."

# Initialize Git
git init
git config user.name "Karlsen Developer"
git config user.email "dev@karlsencoin.org"

echo -e "${GREEN}[3/6]${NC} Committing files..."

# Add all files
git add .
git commit -m "Karlsen v3.1.1 - DNS seeder .org migration + fallback peers

- Updated DNS seeders from .com to .org
- Added 11 fallback peers for DNS independence
- Geographic location logging
- Automatic failover mechanism
- GitHub Actions for multi-platform builds

Features:
- DNS independence
- 11 fallback peers (Frankfurt, Moscow, Roubaix, Vancouver, Sofia, Berlin, Nürnberg, Warsaw, Kosovo, Poland, USA)
- Location transparency
- Auto-fallback mechanism
- Backward compatible"

echo -e "${GREEN}[4/6]${NC} Pushing to GitHub..."

# Add remote and push
git remote add origin "${REPO_URL}"
git branch -M main
git push -u origin main

echo -e "${GREEN}[5/6]${NC} Creating release tag..."

# Create tag
git tag -a v3.1.1 -m "Karlsen v3.1.1 - DNS Seeder Independence Release

Features:
- DNS seeders migrated to .org
- 11 fallback peers for network resilience
- Geographic location logging
- Automatic DNS failover
- Multi-platform GitHub Actions builds

Documentation:
- See PATCHES_README.md for complete feature list
- See CHANGELOG_v3.1.1.md for detailed changes
- See DNS_MIGRATION_GUIDE.md for migration details"

git push origin v3.1.1

echo -e "${GREEN}[6/6]${NC} Complete!"
echo ""
echo "================================================"
echo "✅ Successfully published!"
echo "================================================"
echo ""
echo "Repository: https://github.com/${GITHUB_ORG}/${REPO_NAME}"
echo "Release: https://github.com/${GITHUB_ORG}/${REPO_NAME}/releases/tag/v3.1.1"
echo ""
echo "Next steps:"
echo "1. Open the repository on GitHub"
echo "2. Go to Releases → Draft a new release"
echo "3. Select tag: v3.1.1"
echo "4. Add release notes (see GITHUB_PUBLISH_GUIDE_EN.md for template)"
echo "5. Click 'Publish release'"
echo ""
echo "GitHub Actions will build binaries in 10-15 minutes!"
echo ""
