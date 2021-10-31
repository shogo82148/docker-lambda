#!/usr/bin/env bash

set -eux

CURRENT=$(cd "$(dirname "$0")" && pwd)

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name "lambda-docker-repository" \
    --template-file "${CURRENT}/ecr-public.yaml" \
    --capabilities CAPABILITY_IAM
