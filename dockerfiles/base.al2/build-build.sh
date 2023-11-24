#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --load -t lambda-base:build-alami "$CURRENT/build"
