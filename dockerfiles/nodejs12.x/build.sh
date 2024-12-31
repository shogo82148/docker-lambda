#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/shogo82148/lambda-nodejs:12 "$CURRENT/run"
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/shogo82148/lambda-nodejs:build-12 "$CURRENT/build"
