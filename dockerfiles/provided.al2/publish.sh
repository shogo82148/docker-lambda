#!/usr/bin/env bash

set -e

CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.al2.sh" provided.al2 provided al2
