#!/usr/bin/env bash

set -e

CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.al2023.sh" base.al2023 base al2023
