#!/usr/bin/env bash

CURRENT=$(cd "$(dirname "$0")" && pwd)
docker run --rm -v "$CURRENT":/app -w /app gradle:jdk21 gradle build
