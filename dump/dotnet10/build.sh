#!/usr/bin/env bash

set -e

CURRENT=$(cd "$(dirname "$0")" && pwd)
docker run --rm -v "$CURRENT":/app -w /app mcr.microsoft.com/dotnet/sdk:10.0 dotnet publish --output /app/dist/ --configuration Release
