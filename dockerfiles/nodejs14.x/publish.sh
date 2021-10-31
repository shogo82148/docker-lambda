#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64,linux/arm64 --push -t public.ecr.aws/shogo82148/lambda-nodejs:14 "$CURRENT/run"
