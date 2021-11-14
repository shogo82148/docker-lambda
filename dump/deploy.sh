#!/usr/bin/env bash

set -eux

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

# the layer should be deployed firstly.
make -C layer deploy

for FUNCTION in *
do
    if [[ -f "$FUNCTION" ]]; then
        continue
    fi
    if [[ "$FUNCTION" = layer ]]; then
        continue
    fi
    if [[ "$FUNCTION" = templates ]]; then
        continue
    fi

    make -C "$FUNCTION" deploy
done
