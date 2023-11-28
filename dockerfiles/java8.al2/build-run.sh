#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --load -t lambda-java:8.al2-x86_64 "$CURRENT/run"
docker buildx build --platform linux/arm64 --load -t lambda-java:8.al2-arm64 "$CURRENT/run"
