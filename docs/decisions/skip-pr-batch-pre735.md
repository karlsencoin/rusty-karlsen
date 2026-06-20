# SKIP batch: Pre-#735 upstream Kaspa PRs absorbed into Karlsen v3.1.0 baseline

**Date evaluated:** 2026-06-20
**Karlsen branch:** v3.3.0-dev @ f4f0c242

## Background

karlsen-network/rusty-karlsen v3.1.0 release notes (2026-02-13) explicitly
list these upstream Kaspa PRs as absorbed:

- #677 (wallet upstream patch)
- #726 (rare fd overflow fix with utxoindex)
- #703 (payload support in PSKT)
- #667 (vspc min confirmation count)
- #652 (ibd body optimization)

Karl's v3.1.1-baseline snapshot import is built on top of v3.1.0,
so all of the above are implicitly present.

This document records additional pre-#735 PRs verified as already
applied via cherry-pick no-op detection (auto-merge produces zero diff
against HEAD).

## Verified already-applied

### PR #605 — Small fixes related to enabling payload
- **Upstream commit:** `ea6b83e7b78d`
- **Verification:** Cherry-pick produced only Cargo.toml noise conflict;
  `consensus/core/src/hashing/sighash.rs` auto-merged with zero diff
  against HEAD. Confirms the payload-related sighash fixes are already
  present in baseline.

### PR #625 — Instant time instead of SystemTime
- **Upstream commit:** `1ef4bdc6f436`
- **Verification:** Cherry-pick produced only rebrand-noise conflict in
  `rothschild/src/main.rs` (Karlsen uses `karlsen_addr`, upstream uses
  `kaspa_addr`). The actual fix (Instant replacing SystemTime) is already
  present throughout the file (Instant imported line 25, used in HashMap
  types and Instant::now() calls). Zero functional diff.

### PR #657 — Retain index data up to retention period root
- **Upstream commit:** `1243a04663b0`
- **Verification:** Cherry-pick produced 3 conflicts in
  `consensus/src/pipeline/pruning_processor/processor.rs`:
  - Hunk 1 (line 37): rebrand-only noise (`karlsen_*` vs `kaspa_*` imports)
  - Hunk 2 (line 395): Karlsen has a MORE DEFENSIVE variant with a
    `retention_period_root` existence check guarding against prior bad
    pruning state ("Temp — bug fix upgrade logic"). Upstream uses the
    simpler `prune_below_pruning_point` call.
  - Hunk 3 (line 586): Karlsen uses a `self.get_sink_timestamp()` helper;
    upstream inlines `headers_store.get_timestamp(...)`. Equivalent
    semantics, cleaner API on Karlsen side.
- The PR's intent is absorbed and Karlsen has additional improvements.

### PR #658 — Identify & Warn miners with outdated mining rpc flow
- **Upstream commit:** `2c99ea3222c9`
- **Verification:** Cherry-pick produced 2 conflicts in
  `rpc/service/src/service.rs`, both pure noise:
  - Hunk 1 (line 7): rebrand-only (`karlsen_*` vs `kaspa_*` imports)
  - Hunk 2 (line 410): whitespace/indentation difference in the warn!
    message; the BadMerkleRoot warning about "NON-SUPPORTED miner" is
    already present with equivalent semantics on Karlsen side.
  - `rpc/core/src/convert/tx.rs`: zero diff (auto-merge no-op).
- The miner-outdated detection is already in Karlsen baseline.

### PR #698 — Remove temporary dust prevention mechanism
- **Upstream commit:** `fcd9c28f9b21`
- **Decision:** SKIP — Karlsen retains its own dust prevention.
- **Verification:** Cherry-pick produced 53 conflicts; 99% Cargo.toml
  version-bump noise, plus 3 real files:
  - `mining/errors/src/mempool.rs`: PR removes `RejectSpamTransaction`
    enum variant (Karlsen actively uses this variant).
  - `protocol/flows/src/v5/txrelay/flow.rs`: PR removes the spam match
    arm in the txrelay flow.
  - `mining/src/mempool/validate_and_insert_transaction.rs`: PR removes
    Karlsen's specific go-karlsend dust prevention block:
    "if !has_coinbase_input && num_extra_outs > 2 && fee < num_extra_outs * SOMPI_PER_KARLSEN"
- **Rationale:** This anti-spam check is a Karlsen-specific port from
  go-karlsend, not upstream Kaspa code. Removing it would leave low-fee
  multi-output dust transactions free to enter the mempool. Given
  Karlsen's smaller network footprint and current 1 BPS rate, the
  protection remains valuable. Revisit if/when Karlsen transitions to
  higher BPS where fee dynamics shift.


## Deferred (not evaluated, large scope)

### PR #654 — Mining Rule Engine Scaffolding and Sync Rate Rule
- **Upstream commit:** `b9bbd71af8f8`
- **Footprint:** 28 files, +472/-78
- **Decision:** DEFER — framework/scaffolding introduction, not a portable
  bugfix. Should be evaluated as a feature decision (whether Karlsen wants
  the Mining Rule Engine architecture) rather than ported mechanically.
  Revisit after baseline rebase or as part of a dedicated feature cycle.

### PR #694 — windows asm support for Keccak
- **Upstream commit:** `fe7c01a624f8`
- **Footprint:** 8 files, +2336/-45 (mostly inline assembly)
- **Decision:** DEFER — Karlsen's primary PoW is KarlsenHashV2 (FishHashPlus),
  not Keccak. Keccak is used in secondary hashing paths (signatures, etc.)
  but Windows-specific asm optimization offers low value relative to the
  2336-line surface area. Revisit only if a concrete Windows build/test
  perf bottleneck appears.

### PR #702 — IBD Handle Syncer Pruning Movement
- **Upstream commit:** `728222399edc`
- **Footprint:** 27 files, +904/-177
- **Decision:** DEFER — IBD sync state machine fix when pruning moves
  mid-sync. Was tentatively classified as "backward-compatible / acceptable"
  in earlier evaluations, but the 904-line footprint and likely overlap
  with the `pruning_proof/` no-go zone require a dedicated session.
  Revisit after baseline rebase clears the no-go zones.
