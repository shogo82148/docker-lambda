#!/usr/bin/env bash

set -eux

ARCH=$1
FUNCION_NAME=dump-dotnetcore31-${ARCH/_/-}
aws lambda invoke \
    --region us-east-1 \
    --function-name "$FUNCION_NAME" \
    --payload '{}' out.json
