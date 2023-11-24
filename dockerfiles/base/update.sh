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

perl -pi -e 's(^FROM public.ecr.aws/shogo82148/lambda-base:alami[0-9.]+$)(FROM public.ecr.aws/shogo82148/lambda-base:alami.'"$BASE_RUN"')' build/Dockerfile

# downdload the file system
rm -rf "$CURRENT/.tmp"
mkdir "$CURRENT/.tmp"
cd "$CURRENT/.tmp"
curl -sSL --retry 3 -o base.tgz "$ARCHIVE_URL"

tar xzf base.tgz --strip-components=2 -- var/lib/rpm
docker run \
    -v "$CURRENT/.tmp/rpm":/rpm \
    --rm \
    --platform linux/amd64 \
    public.ecr.aws/amazonlinux/amazonlinux:1 \
    rpm -qa --dbpath /rpm | grep -v ^gpg-pubkey- | sort > "$CURRENT/packages.txt"

# dump file list
tar tf base.tgz | sort > "$CURRENT/fs.txt"

# clean up
cd "$CURRENT"
rm -rf .tmp
