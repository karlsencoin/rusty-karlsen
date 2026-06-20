# SKIP: PR #629 — Proper tracking of accumulative circulating supply

**Upstream commit:** `cdd43795ac1c82e97058143d5cb607b07df324c9`
**Date evaluated:** 2026-06-20
**Karlsen branch:** v3.3.0-dev @ 77df2a0e

## Decision

SKIP — fix already present in Karlsen baseline (no-op cherry-pick).

## Verification

Karlsen's `indexes/utxoindex/` already contains all PR#629 features:

- `index.rs:33` — `monotonic_circulating_supply: CirculatingSupply` field
- `index.rs:31-32` — explanatory comment matching PR#629 description
- `index.rs:101-102` — monotonic runtime update logic
- `index.rs:185` — reset path for monotonic value
- `supply.rs:48` — `saturating_add_signed(supply_delta)` for signed delta handling
- `supply.rs:16,41` — `update_circulating_supply(CirculatingSupplyDiff)` signature accepts signed type

Cherry-pick attempted: Cargo.lock/toml conflicts (noise), 4 utxoindex files
auto-merged to content identical to HEAD → "nothing to commit". Confirms
the implementation is byte-equivalent.

## Notes

- Fix was apparently absorbed into Karlsen v3.1.1 baseline import (or earlier).
- No action required. The `/info/coinsupply/circulating` RPC endpoint
  reports the monotonic value correctly.
