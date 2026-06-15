#!/bin/bash
# Karlsen v3.1.1 - Build All Platforms
# Builds binaries for Linux, macOS, Windows, and WASM

set -e

echo "================================================"
echo "Karlsen v3.1.1 - Multi-Platform Build Script"
echo "================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    print_error "Rust/Cargo not found. Please install from https://rustup.rs"
    exit 1
fi

RUST_VERSION=$(rustc --version | cut -d' ' -f2)
print_info "Using Rust version: $RUST_VERSION"

# Create output directory
mkdir -p releases
print_status "Created releases/ directory"

# Install targets
print_info "Installing build targets..."
rustup target add x86_64-unknown-linux-musl || true
rustup target add x86_64-apple-darwin || true
rustup target add aarch64-apple-darwin || true
rustup target add x86_64-pc-windows-gnu || true
rustup target add wasm32-unknown-unknown || true

echo ""
echo "Building binaries..."
echo ""

# Build Linux x64
print_info "Building Linux x64 (musl)..."
if cargo build --release --target x86_64-unknown-linux-musl --bin karlsend 2>/dev/null; then
    cd target/x86_64-unknown-linux-musl/release/
    tar -czf ../../../releases/rusty-karlsen-v3.1.1-linux-musl-amd64.tar.gz karlsend
    cd ../../..
    print_status "Linux x64 build complete"
else
    print_error "Linux x64 build failed (musl-tools may not be installed)"
fi

# Build macOS x64 (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "Building macOS x64..."
    if cargo build --release --target x86_64-apple-darwin --bin karlsend; then
        cd target/x86_64-apple-darwin/release/
        zip -q ../../../releases/rusty-karlsen-v3.1.1-macos-amd64.zip karlsend
        cd ../../..
        print_status "macOS x64 build complete"
    else
        print_error "macOS x64 build failed"
    fi

    print_info "Building macOS ARM64..."
    if cargo build --release --target aarch64-apple-darwin --bin karlsend; then
        cd target/aarch64-apple-darwin/release/
        zip -q ../../../releases/rusty-karlsen-v3.1.1-macos-aarch64.zip karlsend
        cd ../../..
        print_status "macOS ARM64 build complete"
    else
        print_error "macOS ARM64 build failed"
    fi
else
    print_info "Skipping macOS builds (not on macOS)"
fi

# Build Windows x64 (cross-compile)
print_info "Building Windows x64 (MinGW)..."
if cargo build --release --target x86_64-pc-windows-gnu --bin karlsend 2>/dev/null; then
    cd target/x86_64-pc-windows-gnu/release/
    zip -q ../../../releases/rusty-karlsen-v3.1.1-windows-gnu-amd64.zip karlsend.exe
    cd ../../..
    print_status "Windows x64 build complete"
else
    print_error "Windows x64 build failed (mingw-w64 may not be installed)"
fi

# Build WASM
if command -v wasm-pack &> /dev/null; then
    print_info "Building WASM SDK..."
    if cd wasm && wasm-pack build --target web --out-dir pkg 2>/dev/null; then
        cd ..
        zip -q -r releases/karlsen-wasm32-sdk-v3.1.1.zip wasm/pkg/
        print_status "WASM SDK build complete"
    else
        cd ..
        print_error "WASM SDK build failed"
    fi
else
    print_info "Skipping WASM build (wasm-pack not installed)"
fi

echo ""
echo "================================================"
echo "Build Summary"
echo "================================================"
echo ""

if [ -d "releases" ] && [ "$(ls -A releases)" ]; then
    print_status "Builds completed successfully!"
    echo ""
    echo "Generated files:"
    ls -lh releases/ | tail -n +2 | awk '{printf "  %s  %s\n", $5, $9}'
    echo ""
    echo "Location: $(pwd)/releases/"
else
    print_error "No builds were successful"
    echo ""
    echo "Common issues:"
    echo "  - Linux: Install musl-tools (apt-get install musl-tools)"
    echo "  - Windows: Install mingw-w64 (apt-get install mingw-w64)"
    echo "  - WASM: Install wasm-pack (curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh)"
    echo ""
    echo "Or use GitHub Actions for automated builds (see CROSS_PLATFORM_BUILD.md)"
fi

echo ""
