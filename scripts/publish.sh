#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && shellcheck "$0"

# These are imported by other packages - wait 30 seconds between each as they have linear dependencies
BASE_CRATES="packages/bindings packages/bindings-test"

ALL_CRATES="contracts/reflect"

SLEEP_TIME=30

for CRATE in $BASE_CRATES; do
  (
    cd "$CRATE"
    echo "Publishing $CRATE"
    cargo publish
    # wait for these to be processed on crates.io
    echo "Waiting for crates.io to recognize $CRATE"
    sleep $SLEEP_TIME
  )
done

for CRATE in $ALL_CRATES; do
  (
    cd "$CRATE"
    echo "Publishing $CRATE"
    cargo publish
  )
done

echo "Everything is published!"
