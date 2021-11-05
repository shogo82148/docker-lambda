#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 -t public.ecr.aws/shogo82148/lambda-go:1 "$CURRENT/run"
docker buildx build --platform linux/amd64 -t public.ecr.aws/shogo82148/lambda-go:build-1 "$CURRENT/build"
