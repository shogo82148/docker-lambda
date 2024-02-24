#!/usr/bin/env bash

set -eux

ARCH=$1
FUNCTION_NAME=dump-go1x-${ARCH/_/-}
aws lambda invoke \
    --region us-east-1 \
    --function-name "$FUNCTION_NAME" \
    --payload '{}' out.json
