#!/usr/bin/env bash

set -eux
ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)
RUNTIME=$1
LANGUAGE=$2
VERSION=$3

publish() {
    local PREFIX=$1
    local RUN_TAG=$PREFIX-$LANGUAGE:$VERSION
    local BUILD_TAG=$PREFIX-$LANGUAGE:build-$VERSION

    docker buildx build --platform linux/amd64 --push -t "$RUN_TAG" "$ROOT/$RUNTIME/run"
    docker buildx build --platform linux/amd64 --push -t "$BUILD_TAG" "$ROOT/$RUNTIME/build"

    if [[ -n ${LAMBDA_IMAGE_VERSION:-} ]]; then
        docker buildx build --platform linux/amd64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION" "$ROOT/$RUNTIME/run"
        docker buildx build --platform linux/amd64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION" "$ROOT/$RUNTIME/build"
    fi
}

publish public.ecr.aws/shogo82148/lambda
publish ghcr.io/shogo82148/lambda
