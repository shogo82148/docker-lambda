#!/usr/bin/env bash

set -eux
PREFIX=$1
CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.al2023.pl" "$PREFIX" lambda-ruby:3.3
