#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64,linux/arm64 -t public.ecr.aws/shogo82148/lambda-java:11 "$CURRENT/run"
docker buildx build --platform linux/amd64,linux/arm64 -t public.ecr.aws/shogo82148/lambda-java:build-11 "$CURRENT/build"
