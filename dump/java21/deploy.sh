#!/usr/bin/env bash

set -eux

ARCH=$1
CURRENT=$(cd "$(dirname "$0")" && pwd)

# upload the code
BUCKET=$(aws cloudformation describe-stacks \
    --region us-east-1 \
    --stack-name s3 \
    --output text \
    --query "Stacks[0].Outputs[?OutputKey=='Bucket'] | [0].OutputValue")
DIGEST=$(< "$CURRENT/build/distributions/app.zip" openssl dgst -sha256 -r | cut -d" " -f1)
KEY=code/java21/$DIGEST
aws s3 cp "$CURRENT/build/distributions/app.zip" "s3://$BUCKET/$KEY"

# get the arn of dump layer
LAYER=$(aws cloudformation describe-stacks \
    --region us-east-1 \
    --stack-name "docker-lambda-dump-${ARCH/_/-}" \
    --output text \
    --query "Stacks[0].Outputs[?OutputKey=='DumpLayer'] | [0].OutputValue")

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name "lambda-dump-java21-${ARCH/_/-}" \
    --parameter-overrides \
        "Name=dump-java21-${ARCH/_/-}" \
        "DumpLayer=$LAYER" \
        "S3Bucket=$BUCKET" \
        "S3Key=$KEY" \
        "Architecture=$ARCH" \
    --template-file "${CURRENT}/template.yaml" \
    --capabilities CAPABILITY_IAM
