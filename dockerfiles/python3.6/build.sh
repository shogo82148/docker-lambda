#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 -t ghcr.io/shogo82148/lambda-python:3.6 "$CURRENT/run"
docker buildx build --platform linux/amd64 -t ghcr.io/shogo82148/lambda-python:build-3.6 "$CURRENT/build"
