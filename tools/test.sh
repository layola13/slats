#!/bin/sh
set -eu
: "${SA_STD_DIR:=/opt/sa/std/sa_std}"
export SA_STD_DIR
cd "$(dirname "$0")/.."
# `sla test` accepts a single file; the SA backend runs the emitted `.test.sa` directly.
sla test --test-backend sa crates/tsrs_spanmap/src/spanmap_test.sla "$@"
sla test --test-backend sa crates/tsrs_core/src/core_small_test.sla "$@"
