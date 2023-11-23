#!/usr/bin/env bash

set -euxo pipefail

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

# fetch the latest base image
METADATA=$(curl -sSL --retry 3 "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/base.json")
ARCHIVE_URL=$(echo "$METADATA" | jq -r .url)
export ARCHIVE_URL

# update Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL=.*$/ENV ARCHIVE_URL="$ENV{ARCHIVE_URL}"/g' Dockerfile
