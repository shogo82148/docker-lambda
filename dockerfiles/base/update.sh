#!/usr/bin/env bash

set -euxo pipefail

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

# fetch the latest base image
METADATA=$(curl -sSL --retry 3 "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/base.json")
ARCHIVE_URL=$(echo "$METADATA" | jq -r .url)
export ARCHIVE_URL

# update Dockerfile
perl -pi -e 's/^ENV ARCHIVE_URL=.*$/ENV ARCHIVE_URL="$ENV{ARCHIVE_URL}"/g' run/Dockerfile

# fetch the latest base image
BASE_RUN=$(gh api --jq '[.[].ref] | sort | last' /repos/shogo82148/docker-lambda/git/matching-refs/tags/base-run/ | cut -d/ -f4)

perl -pi -e 's(^FROM public.ecr.aws/shogo82148/lambda-base:alami[0-9.]+$)(FROM public.ecr.aws/shogo82148/lambda-base:alami.'$BASE_RUN')' build/Dockerfile
