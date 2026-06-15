# Karlsen v3.1.1 - DNS Seeder Independence Patch

This is a patched version of rusty-karlsen v3.1.0 upgraded to v3.1.1 with DNS seeder independence features.

## What's Changed

This patched version includes the following enhancements:

### 1. DNS Seeder Update (.org Migration)
- **Updated DNS seeders** from `.com` to `.org`
- `mainnet-dnsseed-1.karlsencoin.org`
- `mainnet-dnsseed-2.karlsencoin.org`
- Aligns with official Karlsen DNS seeder infrastructure

### 2. Fallback Peer System
- **11 hardcoded fallback peers** from diverse geographic locations
- Automatic fallback when DNS seeders are unavailable or fail
- No single point of failure for network bootstrapping

### 2. Geographic Location Logging
- Each fallback peer displays its location when added
- Example log output:
  ```
  [INFO] Added fallback peer: 72.82.146.74:42111 (Frankfurt, Germany)
  [INFO] Added fallback peer: 194.67.186.21:42111 (Moscow, Russia)
  ```

### 3. Version Update
- Updated from v3.1.0 to v3.1.1
- All workspace packages updated to 3.1.1

## Fallback Peer Locations

11 peers across 9 countries:

| IP:Port | Location |
|---------|----------|
| 72.82.146.74:42111 | Frankfurt, Germany 🇩🇪 |
| 194.67.186.21:42111 | Moscow, Russia 🇷🇺 |
| 51.77.132.161:42111 | Roubaix, France 🇫🇷 |
| 142.44.138.38:42111 | Vancouver, Canada 🇨🇦 |
| 78.83.102.26:42111 | Sofia, Bulgaria 🇧🇬 |
| 83.78.96.42:42111 | Berlin, Germany 🇩🇪 |
| 88.99.173.150:42111 | Nürnberg, Germany 🇩🇪 |
| 149.58.116.83:42111 | Warsaw, Poland 🇵🇱 |
| 46.4.58.228:42111 | Prishtina, Kosovo 🇽🇰 |
| 212.23.222.231:42111 | Poland 🇵🇱 |
| 76.185.19.41:42111 | Estero Heights, United States 🇺🇸 |

## Build Instructions

### Prerequisites

- Rust 1.75.0 or higher (1.82.0+ recommended)
- Cargo
- Build essentials (gcc, pkg-config, libssl-dev)

### Install Rust

```bash
# Linux / macOS / WSL
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Verify installation
rustc --version
cargo --version
```

### Build

```bash
# Build in release mode
cargo build --release --bin karlsend

# Binary location:
# Linux/Mac: target/release/karlsend
# Windows: target/release/karlsend.exe
```

Build time: 10-20 minutes on first build (compiles all dependencies)

### Run

```bash
# Normal operation (uses DNS seeders first, fallback if needed)
./target/release/karlsend --utxoindex --disable-upnp

# Force fallback peers (skip DNS seeders)
./target/release/karlsend --nodnsseed --utxoindex --disable-upnp

# Check version
./target/release/karlsend --version
# Output: karlsend 3.1.1
```

## How It Works

### Connection Flow

```
karlsend v3.1.1 starts
    ↓
Query DNS seeders
    ↓
DNS successful? ──YES──→ Use DNS results
    ↓                        ↓
   NO                    Connect to peers
    ↓                        ↓
Use fallback peers      Peer discovery
    ↓                        ↓
Log each peer with      Cache in AddressManager
geographic location          ↓
    ↓                   Fully connected ✓
Connect to peers
    ↓
Peer discovery
    ↓
Cache in AddressManager
    ↓
Fully connected ✓
```

### Modified Files

The following files have been patched:

1. **consensus/core/src/config/params.rs**
   - Added `fallback_peers: &'static [&'static str]` field to Params
   - Populated MAINNET_PARAMS with 11 peer addresses

2. **components/connectionmanager/src/lib.rs**
   - Added fallback_peers parameter to ConnectionManager
   - Added `get_peer_location()` helper function
   - Added `use_fallback_peers()` method
   - Updated DNS seeder logic to use fallback on failure

3. **protocol/flows/src/service.rs**
   - Added fallback_peers parameter to P2pService
   - Passes fallback_peers to ConnectionManager

4. **karlsend/src/daemon.rs**
   - Passes `config.params.fallback_peers` to P2pService::new()

5. **Cargo.toml**
   - Updated workspace version from 3.1.0 to 3.1.1
   - Updated all package versions to 3.1.1

## Features

✅ **DNS Independence** - Works without DNS seeders  
✅ **Geographic Diversity** - 11 peers across 9 countries  
✅ **Automatic Fallback** - Seamless transition when DNS fails  
✅ **Location Transparency** - See where each peer is located  
✅ **Backward Compatible** - DNS seeders still work as primary method  
✅ **Network Resilience** - No single point of failure  

## Testing

### Test Scenario 1: Normal Operation
DNS seeders work → Use DNS results → Normal connection

### Test Scenario 2: DNS Failure
DNS seeders fail → Use fallback peers → Shows location logs → Connect successfully

### Test Scenario 3: No DNS
Use --nodnsseed flag → Skip DNS entirely → Use fallback peers directly

## Expected Log Output

When fallback peers are used:

```
[INFO] Using fallback peer list (11 peers)
[INFO] Added fallback peer: 72.82.146.74:42111 (Frankfurt, Germany)
[INFO] Added fallback peer: 194.67.186.21:42111 (Moscow, Russia)
[INFO] Added fallback peer: 51.77.132.161:42111 (Roubaix, France)
[INFO] Added fallback peer: 142.44.138.38:42111 (Vancouver, Canada)
[INFO] Added fallback peer: 78.83.102.26:42111 (Sofia, Bulgaria)
[INFO] Added fallback peer: 83.78.96.42:42111 (Berlin, Germany)
[INFO] Added fallback peer: 88.99.173.150:42111 (Nürnberg, Germany)
[INFO] Added fallback peer: 149.58.116.83:42111 (Warsaw, Poland)
[INFO] Added fallback peer: 46.4.58.228:42111 (Prishtina, Kosovo)
[INFO] Added fallback peer: 212.23.222.231:42111 (Poland)
[INFO] Added fallback peer: 76.185.19.41:42111 (Estero Heights, United States)
[INFO] Successfully added 11 fallback peers to address manager
[INFO] P2P Connected to outgoing peer 72.82.146.74:42111
```

## Troubleshooting

### Build Error: "edition2024 is required"

**Solution:** Update Rust to the latest stable version
```bash
rustup update stable
```

### Build Error: "linking with `cc` failed"

**Solution:** Install build dependencies
```bash
# Ubuntu/Debian
sudo apt-get install build-essential pkg-config libssl-dev

# macOS
xcode-select --install
```

### Slow Build

**Normal:** First build takes 10-20 minutes to compile all dependencies

## Maintenance

### Updating Fallback Peers

To update the fallback peer list:

1. Check KGI interface: https://kgi.karlsencoin.org
2. Edit `consensus/core/src/config/params.rs`
3. Update the `fallback_peers` array in `MAINNET_PARAMS`
4. Update `get_peer_location()` function in `components/connectionmanager/src/lib.rs`
5. Rebuild

### Recommended Update Frequency

- **Critical:** Immediately if DNS seeders go down
- **Routine:** Every 3-6 months
- **Ideal:** Before each major release

## License

Same as original rusty-karlsen: ISC License

## Credits

- Original rusty-karlsen: Karlsen Network developers
- DNS independence patches: Applied on 2026-04-12
- Fallback peers sourced from: kgi.karlsencoin.org

---

**Version:** 3.1.1  
**Base Version:** rusty-karlsen v3.1.0  
**Patch Date:** 2026-04-12  
**Status:** Production Ready
