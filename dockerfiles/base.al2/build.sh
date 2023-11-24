#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64,linux/arm64 --load -t public.ecr.aws/shogo82148/lambda-base:al2 "$CURRENT/run"
docker buildx build --platform linux/amd64,linux/arm64 --load -t public.ecr.aws/shogo82148/lambda-base:build-al2 "$CURRENT/build"
