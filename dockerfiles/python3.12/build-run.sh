#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --load -t lambda-python:3.12-x86_64 "$CURRENT/run"
docker buildx build --platform linux/arm64 --load -t lambda-python:3.12-arm64 "$CURRENT/run"
