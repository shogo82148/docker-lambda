#!/usr/bin/env bash

set -eux

if [[ $# -lt 1 || -z "${1:-}" ]]; then
  echo "Usage: $0 <architecture>" >&2
  exit 1
fi
ARCH=$1

case "$ARCH" in
  x86_64|arm64) ;;
  *)
    echo "Unsupported architecture: $ARCH (expected: x86_64 or arm64)" >&2
    exit 1
    ;;
esac
CURRENT=$(cd "$(dirname "$0")" && pwd)

# upload the code
BUCKET=$(aws cloudformation describe-stacks \
    --region us-east-1 \
    --stack-name s3 \
    --output text \
    --query "Stacks[0].Outputs[?OutputKey=='Bucket'] | [0].OutputValue")
DIGEST=$(< "$CURRENT/dist.zip" openssl dgst -sha256 -r | cut -d" " -f1)
KEY=code/dotnet10/$DIGEST
aws s3 cp "$CURRENT/dist.zip" "s3://$BUCKET/$KEY"

# get the arn of dump layer
LAYER=$(aws cloudformation describe-stacks \
    --region us-east-1 \
    --stack-name "docker-lambda-dump-${ARCH/_/-}" \
    --output text \
    --query "Stacks[0].Outputs[?OutputKey=='DumpLayer'] | [0].OutputValue")

aws cloudformation deploy \
    --region us-east-1 \
    --stack-name "lambda-dump-dotnet10-${ARCH/_/-}" \
    --parameter-overrides \
        "Name=dump-dotnet10-${ARCH/_/-}" \
        "DumpLayer=$LAYER" \
        "S3Bucket=$BUCKET" \
        "S3Key=$KEY" \
        "Architecture=$ARCH" \
    --template-file "${CURRENT}/template.yaml" \
    --capabilities CAPABILITY_IAM
