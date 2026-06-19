# PR#777 — P2P compressed header

**Decision:** DEFER to v3.4.0+ (baseline rebase prerequisite)
**Date:** 2026-06-19
**Cycle:** v3.3.0-dev

## Upstream intent
Kaspa PR#777 (Manyfestation, 2025-12-08) introduces a `CompressedHeader`
wire format that omits parent hashes from P2P header messages, since the
receiver can reconstruct them from GHOSTDAG data. Backward-compatible
via a new field in `protocol/p2p/proto/p2p.proto`. 9 commits, ~105 KB
patch, 21 files touched.

## Why defer
The patch depends heavily on the upstream v7 flow layout that Karlsen
has not adopted. Of the 21 touched files, the following do not exist
in our tree:

- `protocol/flows/src/v7/blockrelay/flow.rs`
- `protocol/flows/src/v7/blockrelay/handle_requests.rs`
- `protocol/flows/src/v7/request_antipast.rs`
- `protocol/flows/src/v7/request_headers.rs`
- `protocol/flows/src/v7/request_ibd_blocks.rs`
- `protocol/flows/src/v7/request_pp_proof.rs`
- `protocol/flows/src/v7/request_pruning_point_and_anticone.rs`
- `protocol/flows/src/v8/mod.rs`

Karlsen `protocol/flows/src/v7/` contains only `ibd/`, `mod.rs`, and
`request_ibd_blocks_body.rs`. The v7 request-flow surface that would
consume the compressed format is absent.

## Why cherry-pick is not viable
The consensus/core type (`CompressedHeader`), the protobuf field, and
the `protocol/p2p/src/convert/*` serializers are useless without the
v7 flows that actually negotiate and exchange the compressed messages.
Applying only the lower layers would produce dead code with no
behavioral benefit and a non-trivial maintenance surface.

## Relationship to other deferrals
Same root cause as **PR#810** (v7/blockrelay layout missing). Both
require Karlsen baseline to rebase onto the upstream pre-Toccata v7
reorganization before they become applicable.

This reinforces the **v7 layout no-go zone** alongside the existing
pruning_proof/relations no-go zone — both are upstream refactors
Karlsen has diverged from and cannot be patched piecemeal.

## Revisit when
Karlsen baseline incorporates the upstream v7 flow restructure (likely
a coordinated multi-PR rebase, not a single cherry-pick). Until then,
PR#777, PR#810, and any future v7-flow patches remain blocked.
