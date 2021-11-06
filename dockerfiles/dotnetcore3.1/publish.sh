#!/usr/bin/env bash

CURRENT=$(cd "$(dirname "$0")" && pwd)
"$CURRENT/../scripts/publish.al2.sh" dotnetcore3.1 dotnetcore 3.1
