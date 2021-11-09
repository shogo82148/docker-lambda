#!/usr/bin/env bash

set -eux
ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)
RUNTIME=$1
LANGUAGE=$2
VERSION=$3

RUN_TAG=public.ecr.aws/shogo82148/lambda-$LANGUAGE:$VERSION
BUILD_TAG=public.ecr.aws/shogo82148/lambda-$LANGUAGE:build-$VERSION

docker buildx build --platform linux/amd64,linux/arm64 --push -t "$RUN_TAG" "$ROOT/$RUNTIME/run"
docker buildx build --platform linux/amd64 --push -t "$RUN_TAG-x86_64" "$ROOT/$RUNTIME/run"
docker buildx build --platform linux/arm64 --push -t "$RUN_TAG-arm64" "$ROOT/$RUNTIME/run"

docker buildx build --platform linux/amd64,linux/arm64 --push -t "$BUILD_TAG" "$ROOT/$RUNTIME/build"
docker buildx build --platform linux/amd64 --push -t "$BUILD_TAG-x86_64" "$ROOT/$RUNTIME/build"
docker buildx build --platform linux/arm64 --push -t "$BUILD_TAG-arm64" "$ROOT/$RUNTIME/build"

if [[ -n ${LAMBDA_IMAGE_VERSION:-} ]]; then
    docker buildx build --platform linux/amd64,linux/arm64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION" "$ROOT/$RUNTIME/run"
    docker buildx build --platform linux/amd64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION-x86_64" "$ROOT/$RUNTIME/run"
    docker buildx build --platform linux/arm64 --push -t "$RUN_TAG.$LAMBDA_IMAGE_VERSION-arm64" "$ROOT/$RUNTIME/run"

    docker buildx build --platform linux/amd64,linux/arm64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION" "$ROOT/$RUNTIME/build"
    docker buildx build --platform linux/amd64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION-x86_64" "$ROOT/$RUNTIME/build"
    docker buildx build --platform linux/arm64 --push -t "$BUILD_TAG.$LAMBDA_IMAGE_VERSION-arm64" "$ROOT/$RUNTIME/build"
fi
