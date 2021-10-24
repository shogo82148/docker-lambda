#!/usr/bin/env bash

set -eux

ARCH=$1
CURRENT=$(cd "$(dirname "$0")" && pwd)

BUCKET=$(aws cloudformation describe-stacks \
    --region us-east-1 \
    --stack-name s3 \
    --output text \
    --query "Stacks[0].Outputs[?OutputKey=='Bucket'] | [0].OutputValue")
DIGEST=$(openssl sha256 < "$CURRENT/dist/$ARCH.zip")
aws s3 cp "$CURRENT/dist/$ARCH.zip" "s3://$BUCKET/dump-layer/$DIGEST"
STACK=docker-lambda-dump-${ARCH/_/-}

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name "$STACK" \
    --parameter-overrides "S3Bucket=$BUCKET" "S3Key=dump-layer/$DIGEST" "Architecture=$ARCH" \
    --template-file "${CURRENT}/template.yaml"
