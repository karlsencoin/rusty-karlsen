# Karlsen v3.1.1 - GitHub Publishing Guide

## 📋 Prerequisites

- ✅ GitHub account with access to karlsencoin organization
- ✅ Git installed
- ✅ Updated source code (`karlsen-v3.1.1-patched-source.tar.gz`)
- ✅ GitHub personal access token (with push permissions)

---

## 🔐 Step 0: Create GitHub Personal Access Token

1. GitHub.com → Settings → Developer settings → Personal access tokens
2. Click "Generate new token" (Classic)
3. Select permissions:
   - ✅ `repo` (all repository permissions)
   - ✅ `workflow` (GitHub Actions)
4. Copy the token (you won't see it again!)

---

## 📦 PART 1: Publish rusty-karlsen v3.1.1

### Step 1: Prepare Source Code

```bash
# Extract the archive
tar -xzf karlsen-v3.1.1-patched-source.tar.gz
cd rusty-karlsen-3.1.0

# Initialize Git
git init
git add .
git commit -m "Karlsen v3.1.1 - DNS seeder .org migration + fallback peers"
```

### Step 2: Create GitHub Repository

**Via Web Interface:**
1. Go to https://github.com/karlsencoin
2. Click "New repository"
3. Repository settings:
   - **Name:** `rusty-karlsen`
   - **Description:** `Karlsen v3.1.1 - GPU-friendly BlockDAG with DNS independence`
   - **Public** ✅
   - ❌ **Do NOT add** README, .gitignore, or license (empty repo)
4. Click "Create repository"

### Step 3: Push Code

```bash
# Add remote
git remote add origin https://github.com/karlsencoin/rusty-karlsen.git

# Create main branch
git branch -M main

# Push (will ask for token)
git push -u origin main
```

**Note:** Use your Personal Access Token as the password!

### Step 4: Create Release

**Via Web Interface:**

1. Go to https://github.com/karlsencoin/rusty-karlsen
2. Right side "Releases" → "Create a new release"
3. Release information:
   - **Tag:** `v3.1.1`
   - **Release title:** `Karlsen v3.1.1 - DNS Independence Release`
   - **Description:**
   ```markdown
   # Karlsen v3.1.1 - DNS Seeder Independence
   
   ## 🔄 What's New
   
   ### DNS Seeder Migration (.com → .org)
   - Updated DNS seeders to `.org` domains
   - `mainnet-dnsseed-1.karlsencoin.org`
   - `mainnet-dnsseed-2.karlsencoin.org`
   
   ### Fallback Peer System
   - 11 hardcoded fallback peers from diverse geographic locations
   - Automatic failover when DNS seeders are unavailable
   - Geographic location logging for each peer
   
   ### Features
   - ✅ DNS independence - works without DNS seeders
   - ✅ 11 fallback peers (Frankfurt, Moscow, Roubaix, Vancouver, Sofia, Berlin, Nürnberg, Warsaw, Kosovo, Poland, USA)
   - ✅ Location transparency - see where each peer is located
   - ✅ Auto-fallback mechanism - seamless failover
   - ✅ Backward compatible - DNS seeders still work as primary method
   
   ## 📥 Downloads
   
   Pre-built binaries are automatically generated via GitHub Actions and will be available below shortly.
   
   Platform builds:
   - Linux x64 (musl static binary)
   - macOS x64 (Intel)
   - macOS ARM64 (Apple Silicon)
   - Windows x64 (MSVC)
   - WASM SDK (web)
   
   ## 🔨 Build from Source
   
   ```bash
   git clone https://github.com/karlsencoin/rusty-karlsen.git
   cd rusty-karlsen
   git checkout v3.1.1
   cargo build --release --bin karlsend
   ```
   
   ## 📚 Documentation
   
   - `PATCHES_README.md` - Complete feature list and technical details
   - `CHANGELOG_v3.1.1.md` - Detailed changelog
   - `DNS_MIGRATION_GUIDE.md` - DNS migration guide and testing
   - `CROSS_PLATFORM_BUILD.md` - Manual build instructions for all platforms
   
   ## 🧪 Testing
   
   ### Verify DNS seeders:
   ```bash
   ./karlsend --utxoindex --disable-upnp
   # Expected log: Querying DNS seeder mainnet-dnsseed-1.karlsencoin.org
   ```
   
   ### Test fallback peers:
   ```bash
   ./karlsend --nodnsseed --utxoindex --disable-upnp
   # Expected log: Using fallback peer list (11 peers)
   # Expected log: Added fallback peer: 72.82.146.74:42111 (Frankfurt, Germany)
   ```
   
   ## ⚠️ Important Notes
   
   - This release updates DNS seeders from `.com` to `.org`
   - Both `.com` and `.org` seeders should remain operational during transition period
   - Fallback peers provide redundancy if DNS fails
   - Compatible with v3.1.0 network
   
   ## 🔗 Resources
   
   - **DNS Seeder:** https://github.com/karlsencoin/dnsseeder
   - **Discord:** https://discord.com/invite/NUeKN7vWp4
   - **Telegram:** https://t.me/KarlsenNetwork
   
   ---
   
   **Full Changelog:** https://github.com/karlsencoin/rusty-karlsen/compare/v3.1.0...v3.1.1
   ```

4. Click **"Publish release"**

### Step 5: (Optional) GitHub Actions Auto-Build

The repository already includes `.github/workflows/build.yml` which will:
- Build automatically on every tag
- Generate binaries for Linux, macOS, Windows, WASM
- Automatically attach binaries to the release

**To activate:**

Simply push the tag (already done if you followed Step 4):
```bash
git tag v3.1.1
git push origin v3.1.1
```

Binaries will appear in the release page after 10-15 minutes!

---

## 📦 PART 2: Publish dnsseeder

### Step 1: Clone dnsseeder Repository

```bash
# Clone the original repository
git clone https://github.com/karlsen-network/dnsseeder.git
cd dnsseeder
```

### Step 2: Add .org Support (if needed)

Check if the DNS seeder code needs updates:

```bash
# Review config.go
cat config.go | grep -A 5 "Host"
```

If there are hardcoded `.com` addresses, update them to `.org` or make them configurable.

### Step 3: Create GitHub Repository

**Via Web Interface:**
1. https://github.com/karlsencoin → "New repository"
2. Repository settings:
   - **Name:** `dnsseeder`
   - **Description:** `Karlsen DNS Seeder - Provides peer discovery for the Karlsen network`
   - **Public** ✅
3. Click "Create repository"

### Step 4: Push Code

```bash
# Change remote or add new one
git remote set-url origin https://github.com/karlsencoin/dnsseeder.git
# or
git remote add karlsencoin https://github.com/karlsencoin/dnsseeder.git

# Push
git push karlsencoin main
# or push all branches
git push karlsencoin --all
git push karlsencoin --tags
```

### Step 5: Update README

Update `README.md` to include `.org` domains:

```markdown
# Karlsen DNS Seeder

DNS Seeder for Karlsen Network, providing peer discovery via DNS protocol.

## Official DNS Seeders

- `mainnet-dnsseed-1.karlsencoin.org`
- `mainnet-dnsseed-2.karlsencoin.org`
- `testnet-1-dnsseed.karlsencoin.org`

## Quick Start

```bash
# Build
go build .

# Run
./dnsseeder \
  -n ns1.karlsencoin.org \
  -H mainnet-dnsseed-1.karlsencoin.org \
  -s [KARLSEND_NODE_IP]
```

## DNS Configuration

Set up the following DNS records:

```dns
mainnet-dnsseed-1.karlsencoin.org.    A    [YOUR_IP]
ns1.karlsencoin.org.                  A    [YOUR_IP]
```

See full documentation for detailed setup instructions.

[... rest of README ...]
```

Commit and push:
```bash
git add README.md
git commit -m "Update DNS seeder documentation for .org domains"
git push
```

### Step 6: Create Release (Optional)

1. Go to https://github.com/karlsencoin/dnsseeder
2. "Releases" → "Create a new release"
3. Tag: `v2.0.1` (or current version)
4. Description: DNS seeder features and setup instructions

---

## 🎯 Quick Command Summary

### For rusty-karlsen:

```bash
# 1. Prepare
tar -xzf karlsen-v3.1.1-patched-source.tar.gz
cd rusty-karlsen-3.1.0

# 2. Initialize Git
git init
git add .
git commit -m "Karlsen v3.1.1 - DNS seeder .org migration + fallback peers"

# 3. Push
git remote add origin https://github.com/karlsencoin/rusty-karlsen.git
git branch -M main
git push -u origin main

# 4. Create tag
git tag v3.1.1
git push origin v3.1.1
```

### For dnsseeder:

```bash
# 1. Clone
git clone https://github.com/karlsen-network/dnsseeder.git
cd dnsseeder

# 2. Change remote
git remote add karlsencoin https://github.com/karlsencoin/dnsseeder.git

# 3. Push
git push karlsencoin main --all
git push karlsencoin --tags
```

---

## 📊 Expected Results

### https://github.com/karlsencoin/rusty-karlsen
   - ✅ Complete source code
   - ✅ v3.1.1 release
   - ✅ GitHub Actions workflow
   - ✅ Documentation (PATCHES_README.md, CHANGELOG, etc.)
   - ✅ Auto-generated binaries (after 10-15 minutes)

### https://github.com/karlsencoin/dnsseeder
   - ✅ DNS seeder source code
   - ✅ README with .org domains
   - ✅ All branches and tags

---

## 🔍 Verification

### Verify rusty-karlsen:

```bash
# Clone and check
git clone https://github.com/karlsencoin/rusty-karlsen.git
cd rusty-karlsen
git checkout v3.1.1

# Verify DNS seeders
grep "karlsencoin.org" consensus/core/src/config/params.rs
# Output should show: dns_seeders: &["mainnet-dnsseed-1.karlsencoin.org", ...]

# Build
cargo build --release --bin karlsend

# Verify version
./target/release/karlsend --version
# Output: karlsend 3.1.1
```

### Verify dnsseeder:

```bash
# Clone
git clone https://github.com/karlsencoin/dnsseeder.git
cd dnsseeder

# Build
go build .

# Test
./dnsseeder -h
```

---

## ⚠️ Common Issues

### "Permission denied" error

**Solution:** Use Personal Access Token:
```bash
git remote set-url origin https://YOUR_TOKEN@github.com/karlsencoin/rusty-karlsen.git
```

### GitHub Actions not running

**Solution:** 
1. Settings → Actions → General
2. Select "Allow all actions and reusable workflows"
3. Enable "Read and write permissions"

### Binaries not appearing in release

**Solution:**
1. Check Actions tab
2. Verify build succeeded
3. Check workflow file is correct

---

## 🎉 Success Checklist

✅ https://github.com/karlsencoin/rusty-karlsen repository created  
✅ v3.1.1 tag pushed  
✅ Release created  
✅ GitHub Actions running (generating binaries)  
✅ https://github.com/karlsencoin/dnsseeder repository created  
✅ README includes .org domains  

**Everything ready!** 🚀

---

**Prepared by:** Claude  
**Date:** 2026-04-17  
**Version:** 3.1.1
