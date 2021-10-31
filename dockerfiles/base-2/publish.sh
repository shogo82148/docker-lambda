#!/usr/bin/env bash

set -eux
docker buildx build --platform linux/amd64,linux/arm64 --push -t public.ecr.aws/shogo82148/lambda-base:2 .
