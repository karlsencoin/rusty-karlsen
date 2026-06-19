# PR#944 — non-deterministic tests fix (FD limit + port allocation subset)

**Decision:** PARTIAL PORT — 5 of 9 commits applied (see
v3.3.0-dev commit "test: port PR#944 ..."), remaining 4 commits
deferred.
**Date:** 2026-06-19
**Cycle:** v3.3.0-dev

## Deferred commits
The following commits from upstream PR#944 conflict with the Karlsen
testing/integration tree and are NOT applied:

| # | Subject                                             | Files |
|---|-----------------------------------------------------|-------|
| 5 | Fix integration tests to use 100 as FD limit        | testing/integration/src/rpc_tests.rs, testing/integration/src/tasks/daemon.rs, utils/src/fd_budget.rs |
| 6 | Make TEST_FD_LIMIT maximum for tests, in case OS limit is lower | same as #5 |
| 7 | Remove OS free port allocation and just use a random port instead | testing/integration/src/common/daemon.rs |
| 8 | clippy (cleanup for #7)                             | testing/integration/src/common/daemon.rs |

## Why defer
- Commits 5-6 touch a shared `TEST_FD_LIMIT` constant and the
  `fd_budget` accounting that Karlsen has evolved independently.
  Applying upstream's specific numeric choices and refactor would
  conflict with our own test-harness configuration.
- Commits 7-8 replace the existing OS-assigned free-port helper with
  a random-port strategy. Karlsen's `common/daemon.rs` has diverged
  in setup/teardown ordering; a blind port-allocation rewrite would
  risk flakier integration tests, not fewer.

These four are test-infrastructure changes, not correctness fixes —
the cost/benefit of forcing them through manual conflict resolution
is poor compared with the 5 narrower fixes that did apply cleanly.

## Revisit when
Karlsen testing/integration is restructured (or we hit a genuine
flake whose root cause matches #5-#8). At that point port the
intent in our own style, rather than carrying these specific
upstream patches forward.
