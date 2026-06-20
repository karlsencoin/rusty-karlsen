# SKIP: PR #1046 — Fix script engine handling of unknown script versions

**Upstream commit:** `4e8f3135828d9c77146469424ba5a0801ea626e3`
**Date evaluated:** 2026-06-20
**Karlsen branch:** v3.3.0-dev @ aae26e4a

## Decision

SKIP — bug does not exist in Karlsen.

## Rationale

PR#1046 fixes a bug in upstream's two-function architecture
(`execute()` calling `execute_inner()`):

- `execute_inner()` returns `Ok(())` on unknown script version
- `execute()` then unconditionally calls `check_error_condition(true)`
- Unknown version path runs stack validation despite skipping execution → bug

Karlsen uses a single-function architecture: `execute()` does everything
inline. The early-return for unknown version exits the entire function
before `check_error_condition` is reached. The bug is structurally
impossible in Karlsen's code path.

## Verification

`crypto/txscript/src/lib.rs:375-420` — Karlsen's `execute()`:
- Line 380: `return Ok(())` on `version > MAX_SCRIPT_PUBLIC_KEY_VERSION`
- Line 419: `check_error_condition(true)?` — unreachable for unknown version

## Notes

- Cherry-pick attempted, conflicts revealed architectural divergence.
- Aborted cleanly.
- Test case in PR#1046 uses Toccata-only terminology (`compute_commit`,
  `covenant`, `EngineCtx`), would not compile against Karlsen baseline.
- A native Karlsen test confirming this behavior may be worth adding later
  but is not blocking.
