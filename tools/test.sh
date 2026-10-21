#!/bin/sh
set -eu
: "${SA_STD_DIR:=/opt/sa/std/sa_std}"
export SA_STD_DIR
cd "$(dirname "$0")/.."
sla test --test-backend sa crates/tsrs_spanmap/src/spanmap_test.sla "$@"
