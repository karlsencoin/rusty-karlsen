# Changelog

All notable changes to the Karlsen node will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.2.0] - 2026-06-17

Foundations release. Focused on build/ops infrastructure, MSRV modernization,
and consensus/RPC correctness fixes on top of the v3.1.1 patched baseline.

### Added
- **RocksDB preset system** with HDD-optimized profile, selectable via configuration
  for operators running on spinning disks or constrained I/O environments.
- **Environment-variable overrides for karlsend CLI arguments**, enabling cleaner
  systemd/Docker deployments without long ExecStart lines.
- **Dockerfiles** for `karlsend`, `karlsen-wallet`, `simpa`, and `rothschild`,
  providing reproducible container builds for all primary workspace binaries.
- **CONTRIBUTING.md** documenting branch model, commit conventions, and the
  patch-staging workflow used by the Karlsen fork.

### Changed
- **MSRV bumped to Rust 1.88.0** (from 1.75.0). Required for newer dependency
  versions and modern lint coverage. Builders must update their toolchain.
- **`consensusmanager`**: extracted `reset_handlers` logic into a public method
  so external components can trigger reset paths without duplicating internals.

### Fixed
- **`consensus`**: `estimate_block_count` now uses `saturating_sub` to prevent
  arithmetic overflow on edge-case DAG states.
- **`rpc`**: `GetBlocks` now filters the sink anticone to prevent duplicate
  hashes from being returned to clients.
- **`wallet-wasm`**: dropped `Eq` derive that became incompatible with newer
  `wasm-bindgen` `JsValue`, unblocking WASM builds on the updated toolchain.

### Deferred to v3.3.0
The following workstreams were scoped out of this release and remain staged as
patches under `/root/kaspa-prs/` for the next cycle:
- 5.2 — BPS-aware feerate estimator (`target_time_per_block_seconds`).
- 5.3 — Frontier BPS constructor and mempool sampling adjustments.
- 5.4 — Related mempool/transactions-pool follow-ups.

## [3.1.1] - 2026-06 (baseline)

Patched baseline imported from upstream rusty-karlsen v3.1.1. See prior release
notes for details.

[3.2.0]: https://github.com/karlsencoin/rusty-karlsen/releases/tag/v3.2.0
[3.1.1]: https://github.com/karlsencoin/rusty-karlsen/releases/tag/v3.1.1
