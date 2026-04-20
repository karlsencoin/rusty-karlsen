# Karlsen v3.1.1 - Cross-Platform Build Guide

This guide shows how to build karlsend v3.1.1 for all platforms manually.

## Prerequisites

- Rust 1.82.0 or higher
- Platform-specific toolchains (see below)

## Quick Setup: Automated Builds with GitHub Actions

**Easiest method:** Use the included GitHub Actions workflow to automatically build for all platforms.

### Setup Steps:

1. Create a GitHub repository
2. Push your patched source code
3. Create `.github/workflows/` directory
4. Copy `build.yml` to `.github/workflows/build.yml`
5. Create a git tag and push:
   ```bash
   git tag v3.1.1
   git push origin v3.1.1
   ```

GitHub will automatically build binaries for:
- Linux x64 (musl)
- macOS x64
- macOS ARM64
- Windows x64
- WASM SDK

Artifacts will be available in the release page.

---

## Manual Cross-Platform Builds

### 1. Linux x64 (musl) - Static Binary

```bash
# Install musl target
rustup target add x86_64-unknown-linux-musl

# Install musl-gcc
sudo apt-get install musl-tools  # Ubuntu/Debian
# or
brew install filosottile/musl-cross/musl-cross  # macOS

# Build
cargo build --release --target x86_64-unknown-linux-musl --bin karlsend

# Output: target/x86_64-unknown-linux-musl/release/karlsend
```

**Package:**
```bash
cd target/x86_64-unknown-linux-musl/release/
tar -czf rusty-karlsen-v3.1.1-linux-musl-amd64.tar.gz karlsend
```

---

### 2. macOS x64 (Intel)

**On macOS (Intel or Apple Silicon):**

```bash
# Install target
rustup target add x86_64-apple-darwin

# Build
cargo build --release --target x86_64-apple-darwin --bin karlsend

# Output: target/x86_64-apple-darwin/release/karlsend
```

**Package:**
```bash
cd target/x86_64-apple-darwin/release/
zip rusty-karlsen-v3.1.1-macos-amd64.zip karlsend
```

---

### 3. macOS ARM64 (Apple Silicon)

**On macOS Apple Silicon:**

```bash
# Install target
rustup target add aarch64-apple-darwin

# Build
cargo build --release --target aarch64-apple-darwin --bin karlsend

# Output: target/aarch64-apple-darwin/release/karlsend
```

**On macOS Intel (cross-compile):**
```bash
# Install target
rustup target add aarch64-apple-darwin

# Build (may require Xcode)
cargo build --release --target aarch64-apple-darwin --bin karlsend
```

**Package:**
```bash
cd target/aarch64-apple-darwin/release/
zip rusty-karlsen-v3.1.1-macos-aarch64.zip karlsend
```

---

### 4. Windows x64

**On Windows:**

```powershell
# Install target (usually already installed)
rustup target add x86_64-pc-windows-msvc

# Ensure Visual Studio Build Tools are installed
# Download from: https://visualstudio.microsoft.com/downloads/

# Build
cargo build --release --target x86_64-pc-windows-msvc --bin karlsend

# Output: target\x86_64-pc-windows-msvc\release\karlsend.exe
```

**Package:**
```powershell
cd target\x86_64-pc-windows-msvc\release\
Compress-Archive -Path karlsend.exe -DestinationPath rusty-karlsen-v3.1.1-windows-msvc-amd64.zip
```

**Cross-compile from Linux:**

```bash
# Install MinGW
sudo apt-get install mingw-w64

# Install target
rustup target add x86_64-pc-windows-gnu

# Configure cargo for cross-compilation
cat >> ~/.cargo/config.toml << EOF
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
ar = "x86_64-w64-mingw32-ar"
EOF

# Build
cargo build --release --target x86_64-pc-windows-gnu --bin karlsend

# Output: target/x86_64-pc-windows-gnu/release/karlsend.exe
```

---

### 5. WASM SDK

```bash
# Install wasm-pack
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Install target
rustup target add wasm32-unknown-unknown

# Build
cd wasm
wasm-pack build --target web --out-dir pkg

# Package
cd ..
zip -r karlsen-wasm32-sdk-v3.1.1.zip wasm/pkg/
```

---

## Build All Platforms Script

**Linux/macOS:**

```bash
#!/bin/bash
# build-all.sh

set -e

echo "Building Karlsen v3.1.1 for all platforms..."

# Install all targets
rustup target add x86_64-unknown-linux-musl
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
rustup target add x86_64-pc-windows-gnu
rustup target add wasm32-unknown-unknown

# Create output directory
mkdir -p releases

# Build Linux
echo "Building Linux x64..."
cargo build --release --target x86_64-unknown-linux-musl --bin karlsend
cd target/x86_64-unknown-linux-musl/release/
tar -czf ../../../releases/rusty-karlsen-v3.1.1-linux-musl-amd64.tar.gz karlsend
cd ../../..

# Build macOS x64 (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Building macOS x64..."
    cargo build --release --target x86_64-apple-darwin --bin karlsend
    cd target/x86_64-apple-darwin/release/
    zip ../../../releases/rusty-karlsen-v3.1.1-macos-amd64.zip karlsend
    cd ../../..

    echo "Building macOS ARM64..."
    cargo build --release --target aarch64-apple-darwin --bin karlsend
    cd target/aarch64-apple-darwin/release/
    zip ../../../releases/rusty-karlsen-v3.1.1-macos-aarch64.zip karlsend
    cd ../../..
fi

# Build Windows (cross-compile)
echo "Building Windows x64..."
cargo build --release --target x86_64-pc-windows-gnu --bin karlsend
cd target/x86_64-pc-windows-gnu/release/
zip ../../../releases/rusty-karlsen-v3.1.1-windows-gnu-amd64.zip karlsend.exe
cd ../../..

# Build WASM
echo "Building WASM SDK..."
cd wasm
wasm-pack build --target web --out-dir pkg
cd ..
zip -r releases/karlsen-wasm32-sdk-v3.1.1.zip wasm/pkg/

echo "All builds complete! Check releases/ directory"
ls -lh releases/
```

**Make executable:**
```bash
chmod +x build-all.sh
./build-all.sh
```

---

## Docker-Based Cross-Compilation

For consistent builds across all platforms:

```dockerfile
# Dockerfile.builder
FROM rust:1.82

# Install cross-compilation tools
RUN apt-get update && apt-get install -y \
    musl-tools \
    mingw-w64 \
    && rm -rf /var/lib/apt/lists/*

# Install targets
RUN rustup target add x86_64-unknown-linux-musl && \
    rustup target add x86_64-pc-windows-gnu && \
    rustup target add wasm32-unknown-unknown

# Install wasm-pack
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

WORKDIR /build

CMD ["/bin/bash"]
```

**Build using Docker:**

```bash
# Build Docker image
docker build -t karlsen-builder -f Dockerfile.builder .

# Run builds
docker run -v $(pwd):/build karlsen-builder bash -c "
    cargo build --release --target x86_64-unknown-linux-musl --bin karlsend && \
    cargo build --release --target x86_64-pc-windows-gnu --bin karlsend
"
```

---

## Platform-Specific Notes

### Linux
- **musl** builds are fully static and work on any Linux distribution
- **gnu** builds require glibc and are distribution-specific

### macOS
- Building ARM64 from x64 (or vice versa) requires Xcode
- Both architectures can be built on Apple Silicon Macs natively

### Windows
- **msvc** builds require Visual Studio Build Tools (recommended)
- **gnu** builds use MinGW (easier for cross-compilation from Linux)

### WASM
- Requires Node.js for testing
- Built with `wasm-pack` for web compatibility

---

## Expected Output Files

After building all platforms:

```
releases/
├── rusty-karlsen-v3.1.1-linux-musl-amd64.tar.gz    (~26 MB)
├── rusty-karlsen-v3.1.1-macos-amd64.zip            (~24 MB)
├── rusty-karlsen-v3.1.1-macos-aarch64.zip          (~23 MB)
├── rusty-karlsen-v3.1.1-windows-msvc-amd64.zip     (~25 MB)
└── karlsen-wasm32-sdk-v3.1.1.zip                   (~49 MB)
```

---

## Verification

Test each binary:

```bash
# Linux
./karlsend --version

# macOS
./karlsend --version

# Windows
karlsend.exe --version

# All should output: karlsend 3.1.1
```

---

## Troubleshooting

### "linker `cc` not found"
Install build essentials:
```bash
sudo apt-get install build-essential  # Linux
xcode-select --install                 # macOS
```

### "could not find system library 'ssl'"
Install OpenSSL development files:
```bash
sudo apt-get install libssl-dev pkg-config  # Linux
brew install openssl                        # macOS
```

### Windows cross-compilation fails
Use native Windows build or GitHub Actions instead.

---

## Recommended: GitHub Actions

For production releases, use GitHub Actions (see `build.yml`). It provides:
- ✅ Consistent build environment
- ✅ Automatic artifact generation
- ✅ Release management
- ✅ Build caching
- ✅ No local toolchain setup needed

---

**Version:** 3.1.1  
**Last Updated:** 2026-04-12
