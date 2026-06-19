# Defer PR#800/#801/#857 (Pruning Proof Refactor Group) to v3.4.0+
Date: 2026-06-19
Status: Deferred
Scope: rusty-karlsen v3.3.0-dev cycle

## Decision

Skip upstream Kaspa PRs #800, #801, and #857 — collectively a ~6234-line
refactor of `consensus/src/processes/pruning_proof/` — for the v3.3.0
release. Revisit only if a behavioural deficiency is observed in the
existing pruning proof implementation.

## Rationale

1. **Fork divergence is structural, not cosmetic.** `git apply --check`
   fails on all 78 hunks in PR#800. `--reverse` also fails (the patch is
   not already applied either). `--3way` reports missing blobs because
   the Karlsen baseline imported pruning_proof as a single monolithic
   commit (03e3288), severing the git ancestry needed for fuzzy merge.

2. **The PRs are predominantly refactor, not behaviour.** PR#800's ten
   commits are typos/spacing, enum relocation, renames, ProofContext
   restructuring, level-context introduction, common-ancestor refactor,
   and an Ext-trait extraction. Only commits 05 and 07 carry meaningful
   behavioural intent; the rest are pure code organisation.

3. **Consensus-critical surface, solo maintainer.** A pruning-proof
   regression can silently fork the network and may go undetected for
   weeks. Karlsen has no second pair of eyes on consensus code; the
   risk/reward of porting refactor commits is unfavourable.

4. **Backward compatibility commitment.** Many node operators run older
   Karlsen versions. The bar for consensus-touching changes is "clear
   user-visible benefit," which a refactor does not meet.

## Alternative path taken

Step 5.4 (PR#773, higher relations on-the-fly) proceeds, as it is
smaller, more targeted, and has identifiable behavioural value.
Following 5.4, a broader pre-Toccata PR survey filters upstream commits
that are (a) not Toccata-hardfork-specific, (b) not since reverted or
superseded upstream, and (c) deliver measurable efficiency to Karlsen.

## Re-entry criteria

Re-evaluate this group when any of:
- A pruning-related bug is reported on Karlsen mainnet.
- The Karlsen baseline is rebased onto a newer upstream snapshot
  (which would restore git ancestry and make fuzzy merge viable).
- A second consensus reviewer joins the project.
