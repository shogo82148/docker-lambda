#!/usr/bin/env bash

set -eux
PREFIX=$1
CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.al2.pl" "$PREFIX" lambda-java:build-17
