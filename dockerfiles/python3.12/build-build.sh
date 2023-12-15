#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --load -t lambda-python:build-3.11-x86_64 "$CURRENT/build"
docker buildx build --platform linux/arm64 --load -t lambda-python:build-3.11-arm64 "$CURRENT/build"
