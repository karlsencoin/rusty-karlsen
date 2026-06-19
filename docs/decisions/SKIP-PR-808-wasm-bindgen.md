# PR#808 — wasm-bindgen 0.2.106 bump & related fixes

**Decision:** SKIP (intent realized in Karlsen baseline)
**Date:** 2026-06-19
**Cycle:** v3.3.0-dev
**Related Karlsen commit:** 1f499f4

## Upstream intent
Kaspa PR#808 (D-Stacks, 2026-01-06) bumps `wasm-bindgen` from 0.2.100
to 0.2.106 and adjusts related WASM toolchain dependencies, build
scripts, and tsconfig files. 7 commits, ~33 KB patch, 12 files
touched (including `.github/workflows/ci.yaml`, which does not exist
in Karlsen).

A side effect of the wasm-bindgen 0.2.10x line is that `JsValue` no
longer implements `Eq`, breaking any `#[derive(Eq)]` on opaque types
extending `js_sys::Array`. PR#808 addresses this implicitly through
its bump + the codebase changes it ships.

## Why skip
Karlsen workspace `Cargo.toml` already pins:
This matches the PR#808 target exactly. Karlsen bumped wasm-bindgen
independently earlier in its lineage, and the resulting `JsValue: Eq`
breakage was resolved in commit **1f499f4**:

> fix(wallet-wasm): drop Eq derive incompatible with newer
> wasm-bindgen JsValue
> (wallet/core/src/wasm/signer.rs, 1 line)

The two principal goals of PR#808 — wasm-bindgen 0.2.106 in use and a
clean `cargo check --workspace` despite the JsValue Eq regression —
are both already satisfied.

## Auxiliary bumps NOT applied
PR#808 also touches dependencies that remain on older versions in
Karlsen:

| Crate                  | Karlsen | PR#808 |
|------------------------|---------|--------|
| wasm-bindgen-futures   | 0.4.43  | 0.4.56 |
| wasm-bindgen-test      | 0.3.50  | 0.3.56 |
| web-sys                | 0.3.70  | 0.3.83 |
| js-sys                 | 0.3.77  | 0.3.83 |

These are not behavior-critical and not part of the JsValue Eq
breakage path. They are tracked as a separate, optional WASM
toolchain refresh — to be considered when the wallet/WASM surface is
revisited, not as a PR#808 port.

## Action
None. No commit beyond this decision record.

## File-mode note
For future WASM-related ports: the upstream `wasm/build-*` scripts
are 100755 (executable); Karlsen's are 100644. Any future patch
touching them will need `--allow-mode-change` or a mode normalization
step.
