#!/usr/bin/env bash

set -euxo pipefail

CURRENT=$(cd "$(dirname "$0")" && pwd)
cd "$CURRENT"

# fetch the latest base image
BASE_RUN=$(gh api --jq '[.[].ref] | sort | last' /repos/shogo82148/docker-lambda/git/matching-refs/tags/base-run/ | cut -d/ -f4)
BASE_BUILD=$(gh api --jq '[.[].ref] | sort | last' /repos/shogo82148/docker-lambda/git/matching-refs/tags/base-build/ | cut -d/ -f4)

perl -pi -e 's(^FROM public.ecr.aws/shogo82148/lambda-base:alami[0-9.]+$)(FROM public.ecr.aws/shogo82148/lambda-base:alami.'"$BASE_RUN"')' run/Dockerfile
perl -pi -e 's(^FROM public.ecr.aws/shogo82148/lambda-base:build-alami[0-9.]+$)(FROM public.ecr.aws/shogo82148/lambda-base:build-alami.'"$BASE_BUILD"')' build/Dockerfile
