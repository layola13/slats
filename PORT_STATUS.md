# Port status

Upstream: `oxc-project/tsrs` at `0.18.0-ts7.1.0-dev.20260929` (833 `.rs` files, 571,993 lines,
37 crates). Every upstream file has a mirrored `.sla` placeholder so the tree diff stays 1:1.

## Converted

| path | status | notes |
| --- | --- | --- |
| `crates/tsrs_core/src/text.sla` | ported | `SourcePos`, `TextPos`, `TextRange`, `new_text_range`, `undefined_text_range` |
| `crates/tsrs_core/src/goslices.sla` | ported | `sort_u32`, `binary_search_u32`, `lower_bound_u32` |
| `crates/tsrs_spanmap/src/spanmap.sla` | ported | full crate: validate, index build, both mapping directions, marshal/unmarshal |
| `crates/tsrs_spanmap/src/spanmap_test.sla` | ported | 15 `@test` blocks (the upstream benchmark is not ported) |

## Pending

All remaining crates are mirror stubs with `PORT-STATUS: pending`. Their headers list the upstream
items so the port can proceed crate by crate without re-reading the Rust sources.

Suggested order (fewest dependencies first): `tsrs_core` (rest), `tsrs_sys`, `tsrs_path_util`,
`tsrs_vfs`, `tsrs_ast`, `tsrs_parser`, `tsrs_binder`, `tsrs_checker`, then the API/driver layers.
