#!/usr/bin/env bash

set -eux
CURRENT=$(cd "$(dirname "$0")" && pwd)
docker buildx build --platform linux/amd64 --push -t public.ecr.aws/shogo82148/lambda-python:3.7 "$CURRENT/run"
docker buildx build --platform linux/amd64 --push -t public.ecr.aws/shogo82148/lambda-go:python-3.7 "$CURRENT/build"
