# slats

SLA port of [`oxc-project/tsrs`](https://github.com/oxc-project/tsrs) (the Rust rewrite of the
TypeScript compiler). The layout mirrors the upstream `crates/` tree 1:1 so every `.rs` file has a
same-named `.sla` counterpart carrying `PORT-MIRROR`, `UPSTREAM-LINES` and `PORT-STATUS` headers.

## Status

Only the crates needed for the span-map pipeline are genuinely converted; every other `.sla` file is
a mirror stub (`PORT-STATUS: pending`). See `PORT_STATUS.md`.

Ported and verified:

| crate | files | tests |
| --- | --- | --- |
| `tsrs_core` | `text.sla`, `goslices.sla` (subset) | used by span-map tests |
| `tsrs_spanmap` | `spanmap.sla`, `spanmap_test.sla` | 15/15 pass |

## Requirements

- `sla` + `sa` from the SA toolchain (`/opt/sa/bin`), with `SA_STD_DIR=/opt/sa/std/sa_std`.
- The `sa` verifier patch in `patches/sa-phi-borrow-rewrite.patch`. Without it, the legal
  update-via-move pattern used by `VEC_PUSH` (`%v = call @sa_vec_push(^%v, ...)`) reports a false
  `PhiStateConflict` when the vector is a borrowed parameter updated inside a loop.

## Commands

```sh
export SA_STD_DIR=/opt/sa/std/sa_std

# type-check the ported crates
tools/check.sh

# run the ported tests (SAB lowering cannot handle Vec yet, so use the legacy .sa backend)
tools/test.sh
```

`Sla Compiler: Successfully parsed and verified syntax and types` means the module graph, signatures
and bodies reachable from the entry file all type-check. `sla test` defaults to the direct SAB
backend, which rejects this code with `error.UnsupportedSabDirectFeature`; the `--test-backend sa`
path compiles to `.sa`, then runs `sa test`.
