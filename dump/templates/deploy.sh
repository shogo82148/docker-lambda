#!/usr/bin/env bash

set -eux

CURRENT=$(cd "$(dirname "$0")" && pwd)

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name "s3" \
    --template-file "${CURRENT}/s3.yaml"

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name "github-actions" \
    --template-file "${CURRENT}/github-actions.yaml" \
    --capabilities CAPABILITY_NAMED_IAM
