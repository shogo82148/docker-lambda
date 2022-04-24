#!/usr/bin/env bash

set -eux

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

for FUNCTION in *
do
    if [[ -f "$FUNCTION" ]]; then
        continue
    fi
    if [[ "$FUNCTION" = templates ]]; then
        continue
    fi

    make -C "$FUNCTION" test
done
