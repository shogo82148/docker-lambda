#!/usr/bin/env bash

set -eux
ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)
RUNTIME=$1
LANGUAGE=$2
VERSION=$3

retry () {
    "$@" && return 0
    echo "failed. sleep 30 sec..." 2>&1
    sleep 30

    "$@" && return 0
    echo "failed. sleep 60 sec..." 2>&1
    sleep 60

    "$@" && return 0
    echo "failed. give up :(" 2>&1
    return
}

publish() {
    local PREFIX=$1
    local RUN_TAG=$PREFIX-$LANGUAGE:$VERSION
    local BUILD_TAG=$PREFIX-$LANGUAGE:build-$VERSION

    retry docker buildx build --platform linux/amd64,linux/arm64 --push -t "$RUN_TAG" "$ROOT/$RUNTIME/run"
    retry docker buildx build --platform linux/amd64 --push -t "$RUN_TAG-x86_64" "$ROOT/$RUNTIME/run"
    retry docker buildx build --platform linux/arm64 --push -t "$RUN_TAG-arm64" "$ROOT/$RUNTIME/run"

    retry docker buildx build --platform linux/amd64,linux/arm64 --push -t "$BUILD_TAG" "$ROOT/$RUNTIME/build"
    retry docker buildx build --platform linux/amd64 --push -t "$BUILD_TAG-x86_64" "$ROOT/$RUNTIME/build"
    retry docker buildx build --platform linux/arm64 --push -t "$BUILD_TAG-arm64" "$ROOT/$RUNTIME/build"

    if [[ -n ${LAMBDA_IMAGE_VERSION:-} ]]; then
        retry docker buildx build --platform linux/amd64,linux/arm64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION" "$ROOT/$RUNTIME/run"
        retry docker buildx build --platform linux/amd64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION-x86_64" "$ROOT/$RUNTIME/run"
        retry docker buildx build --platform linux/arm64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION-arm64" "$ROOT/$RUNTIME/run"

        retry docker buildx build --platform linux/amd64,linux/arm64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION" "$ROOT/$RUNTIME/build"
        retry docker buildx build --platform linux/amd64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION-x86_64" "$ROOT/$RUNTIME/build"
        retry docker buildx build --platform linux/arm64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION-arm64" "$ROOT/$RUNTIME/build"
    fi
}

publish public.ecr.aws/shogo82148/lambda
publish ghcr.io/shogo82148/lambda
