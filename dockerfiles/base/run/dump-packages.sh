#!/usr/bin/env bash

set -eux

CURRENT=$(cd "$(dirname "$0")" && pwd)

# download file system
mkdir "$CURRENT/.tmp"
cd "$CURRENT/.tmp"
curl -sSL -O "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/base.tgz"

tar xzf base-2.tgz --strip-components=2 -- var/lib/rpm
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
