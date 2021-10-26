#!/usr/bin/env bash

set -eux
docker buildx build --platform linux/amd64,linux/arm64 -t base-2 .
