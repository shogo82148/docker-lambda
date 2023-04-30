#!/usr/bin/env bash

set -e

CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.al2.sh" python3.10 python 3.10
