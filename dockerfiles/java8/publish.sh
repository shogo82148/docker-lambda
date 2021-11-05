#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --push -t public.ecr.aws/shogo82148/lambda-java:8 "$CURRENT/run"
docker buildx build --platform linux/amd64 --push -t public.ecr.aws/shogo82148/lambda-java:build-8 "$CURRENT/build"
