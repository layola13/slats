#!/bin/sh
set -eu
: "${SA_STD_DIR:=/opt/sa/std/sa_std}"
export SA_STD_DIR
cd "$(dirname "$0")/.."
sla check crates/tsrs_core/src/lib.sla
sla check crates/tsrs_spanmap/src/lib.sla
