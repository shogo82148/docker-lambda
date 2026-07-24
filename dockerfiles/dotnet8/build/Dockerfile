FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/dotnet8/16e7deccc6c7676ae809960cbb93805b7b57de265512eb482385558f29116c0e.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/dotnet8/6c4f1892ce18a3c2458308e0fe91e4b54fc1f9365dd1dce1a95ab0d8f66a2a0e.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.07.24

# Run: docker run --rm --entrypoint dotnet ghcr.io/shogo82148/lambda-dotnetcore:8 --info
# Check https://dotnet.microsoft.com/en-us/download/dotnet/8.0 for versions
ENV DOTNET_ROOT=/var/lang/bin
ENV PATH=/root/.dotnet/tools:$DOTNET_ROOT:$PATH \
  LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
  AWS_EXECUTION_ENV=AWS_Lambda_dotnet6 \
  DOTNET_SDK_VERSION=8.0.420 \
  DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  NUGET_XMLDOC_MODE=skip

COPY --from=0 /var /var

RUN dnf install -y --allowerasing libicu && \
  curl -L https://dot.net/v1/dotnet-install.sh | bash -s -- -v $DOTNET_SDK_VERSION -i $DOTNET_ROOT && \
  mkdir /tmp/warmup && \
  cd /tmp/warmup && \
  dotnet new && \
  cd / && \
  rm -rf /tmp/warmup /tmp/NuGetScratch /tmp/.dotnet

CMD ["dotnet", "build"]
