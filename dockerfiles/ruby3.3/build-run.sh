#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --load -t lambda-ruby:3.3-x86_64 "$CURRENT/run"
docker buildx build --platform linux/arm64 --load -t lambda-ruby:3.3-arm64 "$CURRENT/run"
