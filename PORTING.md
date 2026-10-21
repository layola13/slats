# Porting notes

The port is a 1:1 semantic conversion: same function names, same field names, same constants, same
error strings. Rust idioms that SLA cannot express are replaced by the smallest equivalent shape and
recorded here.

## Limitations (LIM)

| id | Rust | SLA shape | why |
| --- | --- | --- | --- |
| LIM-001 | `new` free fn + `new` method | `new_of` / `new` | SLA has a single call namespace, so a same-named nil-receiver function and method collide. |
| LIM-002 | `Option<T>` return | `(T, bool)` (or a `SegIndex` with flags) | Returning `Option` traps with `MemoryLeak`; `Option` parameters are fine. |
| LIM-003 | generic `sort_func<T>` | per-element-type fns (`sort_u32`, `sort_segments_for_original_index`, ...) | No generics across packages. |
| LIM-004 | closures / `loop` | named helper fns + `while` | No closures, no `loop`. |
| LIM-005 | cross-module struct literal | constructor fns (`kind_from_code`, `feature_from_bits`) | Cross-module literals fail with `error.FieldNotFound`. |
| LIM-006 | variant named like a struct (`Feature`, `Kind`) | trailing `_` (`Feature_`, `Kind_`) | Variant names share the struct namespace. |
| LIM-007 | integer-literal `match` patterns | `if` chains on a discriminant | No literal patterns. |
| LIM-008 | `TextPos::source(offset)` | free fn `text_pos_source(offset)` | `Enum::lowercase_fn(...)` parses as an enum-variant path. |
| LIM-009 | fieldless Copy enums | `@derive(Copy)` structs with `code: u32` + constructors | SLA enums are move-only; a value used twice traps `UseAfterMove`. |

## Deviations (DEV)

| id | upstream | here | why |
| --- | --- | --- | --- |
| DEV-001 | unstable pdqsort | stable merge sort | Determinism, no in-place partitioning on borrowed vectors. |
| DEV-002 | `OnceLock<OriginalIndex>` | built eagerly in `new` | No interior mutability; identical results. |
| DEV-003 | `&str` / `[]byte` | `&Vec<u8>` | `String::bytes()` traps; byte offsets and lengths are unchanged. |
| DEV-004 | `P<SpanMap>` | `SpanMap` by value | No refcounted pointers; the map is small and copied explicitly. |
| DEV-005 | short-circuit `&&` / `\|\|` | nested `if`s when the right side indexes | SLA evaluates both operands: `i < len(v) && v[i] == x` reads out of bounds at `i == len(v)`. |
| DEV-006 | `vec.push(x)` in a loop | unchanged | Requires the `sa` patch in `patches/`; otherwise it is a false `PhiStateConflict`. |

## Backend quirks

- `sla check` reports success even for bodies that are only lazily checked; build a driver that
  calls the entry points to force full checking.
- `sla test` uses the SAB backend by default and fails with `error.UnsupportedSabDirectFeature`;
  pass `--test-backend sa` to emit `.test.sa` and run it with `sa test`.
- `sla build` writes `<file>.sa`; `sa build-exe <file>.sa -o <bin>` produces the executable.
  `sla build-exe` still fails on `Vec::push`.
- A statement-position `if` chain must be followed by `;`; a `while` block must not be.
