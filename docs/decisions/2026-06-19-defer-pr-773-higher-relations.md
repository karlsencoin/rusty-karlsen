# Defer PR#773 (Higher Relations On-the-Fly) to v3.4.0+

Date: 2026-06-19
Status: Deferred
Scope: rusty-karlsen v3.3.0-dev cycle (Step 5.4)

## Decision

Skip upstream Kaspa PR#773 for the v3.3.0 release. The patch is 228 KB
across 59 commits, 221 hunks, and 17 files spanning `pruning_proof/`,
relations stores, header processing pipeline, pruning processor, IBD
flow, simpa, and daemon wiring.

## Rationale

1. **Same fork-divergence wall as PR#800/#801/#857.** Forward apply
   fails on every hunk reaching `pruning_proof/` and relations stores;
   reverse apply also fails. The Karlsen baseline cannot host this
   patch without a prior upstream-snapshot rebase.

2. **Architectural rewrite, not a localised feature.** Commit titles
   include "delete old relations store", "singular relation store",
   "removed relations update from header processing", and "skip pruning
   higher relations". These are pipeline-level changes, not a single
   isolatable behavioural improvement.

3. **Risk profile unchanged from v3.3.0 defer policy.** Consensus-
   critical surface, solo maintainer, weeks-of-silent-regression risk.
   Same reasoning as `2026-06-19-defer-pruning-proof-group.md`.

## Emergent principle: `pruning_proof/` + relations is a no-go zone

PRs #800, #801, #857, and #773 all touch this region and all fail to
apply for the same structural reason. Until the Karlsen baseline is
rebased onto a newer upstream snapshot, **no upstream PR touching
`consensus/src/processes/pruning_proof/` or
`consensus/src/model/stores/relations.rs` will be ported**. Candidate
PRs that fall into this zone are filtered out at intake.

## Re-entry criteria

Same as PR#800/#801/#857 deferral: pruning-related bug report, baseline
rebase, or second consensus reviewer joining.
