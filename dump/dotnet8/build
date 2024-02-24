#!/usr/bin/env bash

CURRENT=$(cd "$(dirname "$0")" && pwd)
docker run --rm -v "$CURRENT":/app -w /app mcr.microsoft.com/dotnet/sdk:8.0 dotnet publish --output /app/dist/ --configuration Release
