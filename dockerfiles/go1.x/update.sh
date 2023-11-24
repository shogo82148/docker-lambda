#!/usr/bin/env bash

set -euxo pipefail

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

# fetch the latest base image
METADATA_AMD64=$(curl -sSL --retry 3 "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/go1.x.json")
ARCHIVE_URL_AMD64=$(echo "$METADATA_AMD64" | jq -r .url)

export ARCHIVE_URL_AMD64

# update Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL_AMD64=.*$/ENV ARCHIVE_URL_AMD64="$ENV{ARCHIVE_URL_AMD64}"/g' run/Dockerfile
