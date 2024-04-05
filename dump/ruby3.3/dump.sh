#!/usr/bin/env bash

set -eux

ARCH=$1
if [ -z "$ARCH" ]; then
  echo "Usage: $0 <architecture>"
  exit 1
fi
FUNCTION_NAME=dump-ruby33-${ARCH/_/-}
aws lambda invoke \
    --region us-east-1 \
    --function-name "$FUNCTION_NAME" \
    --payload '{}' out.json
