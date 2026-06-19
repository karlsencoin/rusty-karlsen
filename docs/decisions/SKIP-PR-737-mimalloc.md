# PR#737 — mimalloc 0.1.48 bump

**Decision:** SKIP (already applied in Karlsen baseline)
**Date:** 2026-06-19
**Cycle:** v3.3.0-dev

## Upstream intent
Kaspa PR#737 (Leon177_7, 2025-10-04) replaces the git-pinned mimalloc
revision (`purpleprotocol/mimalloc_rust @ eff21096`) with the released
crates.io version `0.1.48`, removing the rust-1.87 Windows linker
workaround TODOs.

Touches: `utils/alloc/Cargo.toml` (1 file, 2 insertions, 4 deletions).

## Why skip
Karlsen `utils/alloc/Cargo.toml` already uses `mimalloc = "0.1.48"`
from crates.io for both non-macos and macos targets. The git-rev
workaround that PR#737 removes does not exist in our tree — it was
resolved independently earlier in the Karlsen lineage.

`git apply --check` fails because the `-` lines (the git-rev block)
are not present in our file to remove. The `+` end-state is already
our current state. No behavioral or dependency change would result
from applying this patch.

## Verification
Matches PR#737 target state exactly.

## Action
None. No commit. Move to next candidate (PR#777 compressed header).
