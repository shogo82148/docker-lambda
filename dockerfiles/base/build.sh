#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
IMAGE_TAG=$(< "$CURRENT/build/Dockerfile" perl -ne 'print $1 if /^FROM\s+(.*)$/')
docker buildx build --platform linux/amd64 --load -t "$IMAGE_TAG" "$CURRENT/run"
docker buildx build --platform linux/amd64 --load -t public.ecr.aws/shogo82148/base:build-alami "$CURRENT/build"
