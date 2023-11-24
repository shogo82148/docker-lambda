#!/usr/bin/env bash

set -euxo pipefail

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

# fetch the latest base image
METADATA_AMD64=$(curl -sSL --retry 3 "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/dotnet6.json")
ARCHIVE_URL_AMD64=$(echo "$METADATA_AMD64" | jq -r .url)

METADATA_ARM64=$(curl -sSL --retry 3 "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/dotnet6.json")
ARCHIVE_URL_ARM64=$(echo "$METADATA_ARM64" | jq -r .url)

export ARCHIVE_URL_AMD64
export ARCHIVE_URL_ARM64

# update Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL_AMD64=.*$/ENV ARCHIVE_URL_AMD64="$ENV{ARCHIVE_URL_AMD64}"/g' run/Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL_ARM64=.*$/ENV ARCHIVE_URL_ARM64="$ENV{ARCHIVE_URL_ARM64}"/g' run/Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL_AMD64=.*$/ENV ARCHIVE_URL_AMD64="$ENV{ARCHIVE_URL_AMD64}"/g' build/Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL_ARM64=.*$/ENV ARCHIVE_URL_ARM64="$ENV{ARCHIVE_URL_ARM64}"/g' build/Dockerfile
