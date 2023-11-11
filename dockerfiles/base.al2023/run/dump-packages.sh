#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    $0 x86_64
    $0 arm64
    exit 0
fi

set -euxo pipefail

ARCH=$1
CURRENT=$(cd "$(dirname "$0")" && pwd)

# download file system
rm -rf "$CURRENT/.tmp"
mkdir "$CURRENT/.tmp"
cd "$CURRENT/.tmp"
curl -sSL --retry 3 -O "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$ARCH/base.al2023.tgz"

# dump packages
case "$ARCH" in
    "x86_64")
        PLATFORM=linux/amd64
        ;;
    "arm64")
        PLATFORM=linux/arm64
        ;;
    *)
        echo "unknown architecture: $ARCH"
        exit 1
        ;;
esac

tar xzf base.al2023.tgz --strip-components=2 -- var/lib/rpm
docker run \
    -v "$CURRENT/.tmp/rpm":/rpm \
    --rm \
    --platform "$PLATFORM" \
    public.ecr.aws/amazonlinux/amazonlinux:2023 \
    rpm -qa --dbpath /rpm | grep -v ^gpg-pubkey- | sort > "$CURRENT/packages-$ARCH.txt"

# dump file list
tar tf base.al2023.tgz | sort > "$CURRENT/fs-$ARCH.txt"

# clean up
cd "$CURRENT"
rm -rf .tmp
