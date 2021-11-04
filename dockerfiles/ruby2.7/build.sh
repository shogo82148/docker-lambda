#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64,linux/arm64 -t public.ecr.aws/shogo82148/lambda-ruby:2.7 "$CURRENT/run"
docker buildx build --platform linux/amd64,linux/arm64 -t public.ecr.aws/shogo82148/lambda-ruby:build-2.7 "$CURRENT/build"
