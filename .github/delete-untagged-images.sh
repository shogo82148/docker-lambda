#!/bin/bash

set -euxo pipefail

REPOSITORY=$1

RESULT=$(aws ecr-public describe-images --region us-east-1 --max-items 100 --repository-name "$REPOSITORY")

while true
do
    IDS=$(<<< "$RESULT" jq -c '[ .imageDetails[] | select(.imageTags | length == 0) | { imageDigest: .imageDigest } ]')
    if [[ $(<<< "$IDS" jq -r '. | length') -gt 0 ]]; then
        aws ecr-public batch-delete-image --no-cli-pager --region us-east-1 --repository-name "$REPOSITORY" --image-ids "$IDS"
    fi

    if [[ "$(<<< "$RESULT" jq -r '.NextToken | length')" -eq 0 ]]; then
        break
    fi
    RESULT=$(aws ecr-public describe-images --region us-east-1 --max-items 100 --repository-name "$REPOSITORY" --starting-token "$(echo "$RESULT" | jq .NextToken)")
done
