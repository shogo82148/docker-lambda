#!/usr/bin/env bash

set -eux
PREFIX=$1
CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.pl" "$PREFIX" lambda-base:build-alami
