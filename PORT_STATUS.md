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
| `crates/tsrs_core/src/{tristate,scriptkind,languagevariant,version,pattern,textchange,buildoptions}.sla` | ported | `tsrs_core` leaf modules; `Tristate`/`PatternKind`/`ScriptKind`/`LanguageVariant` are Copy structs (LIM-009), `Pattern` text is bytes (DEV-003) |
| `crates/tsrs_core/src/stringeq.sla` | ported | SLA support module: `string_eq` (DEV-008) |
| `crates/tsrs_core/src/core_small_test.sla` | ported | 12 `@test` blocks covering the modules above |
| `crates/tsrs_core/src/bytesutil.sla` | ported | SLA support module: byte compare/search/copy helpers shared by the byte-text ports |
| `crates/tsrs_core/src/tspath/path.sla` | partial | path primitives: root/URL detection, slash normalization, directory/base name, extensions |
| `crates/tsrs_core/src/tspath/extension.sla` | ported | full `extension.rs`: constants/lists, predicates, declaration/emit extensions, change*Extension |
| `crates/tsrs_core/src/tspath/path_extension_test.sla` | ported | 13 `@test` blocks (ported path_test.rs subset + extension.rs coverage) |

## Pending

All remaining crates are mirror stubs with `PORT-STATUS: pending`. Their headers list the upstream
items so the port can proceed crate by crate without re-reading the Rust sources.

Suggested order (fewest dependencies first): `tsrs_core` (rest), `tsrs_sys`, `tsrs_path_util`,
`tsrs_vfs`, `tsrs_ast`, `tsrs_parser`, `tsrs_binder`, `tsrs_checker`, then the API/driver layers.
