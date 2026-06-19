# PR#970 — cargo audit/deny advisories

**Decision:** DEFER (track as independent Karlsen security audit work,
not as a monolithic upstream port)
**Date:** 2026-06-19
**Cycle:** v3.3.0-dev

## Upstream intent
Kaspa PR#970 (143672 / Biryukov Maxim, 2026-04-28) is a security
hygiene sweep addressing `cargo audit` and `cargo deny` advisories.
4 commits, ~128 KB patch, 31 files touched. Goals:

- Replace unmaintained `async-std`
- Replace `derivative`
- Drop `intertrait` (downcast)
- Bump tokio, rustls, igd-next, log4rs, prometheus, rv

## Why not port as a single patch
The patch fails to apply cleanly across nearly every file:

- `bridge/Cargo.toml` and `bridge/src/prom.rs` do not exist in
  Karlsen (Kaspa-only utility, never adopted).
- Cargo.lock diverges at every touched hunk (independent dep
  evolution since fork).
- Cargo.toml workspace section conflicts (Karlsen has its own
  audit history and unrelated edits).
- `wallet/native/Cargo.toml`, `rpc/wrpc/wasm/Cargo.toml`,
  `testing/integration/*`, `wallet/core/src/prelude.rs` all
  diverge meaningfully.

Forcing a port would require rewriting most of the patch by hand and
would mix Karlsen-specific decisions with upstream ones — exactly the
kind of work that should be driven by **our own** advisory list, not
upstream's snapshot from late April 2026.

## Action plan (v3.3.0 or v3.4.0)
Treat PR#970 as a reference checklist, not a patch:

1. Run `cargo audit` and `cargo deny check` against the current
   Karlsen workspace; capture the output as
   `docs/security/v3.3.0-audit-baseline.txt`.
2. Cross-reference with PR#970's intent list (async-std, derivative,
   intertrait, tokio/rustls/igd-next/log4rs/prometheus/rv bumps).
3. Address each advisory as a small, focused commit:
   - One commit per crate replacement (async-std → tokio/smol,
     derivative → educe or hand-rolled, intertrait removal).
   - One commit per dep bump, paired with workspace .lock sync.
4. Verify each commit independently with `cargo check --workspace`
   and the relevant test surface.

This produces a clean audit trail Karlsen owns, rather than carrying
forward upstream's bundled decisions.

## Action right now
Document the decision. No commit beyond this record. Continue with the
remaining high-value cherry-picks (#964, #944) and start the audit
sweep when those land or in v3.4.0.
