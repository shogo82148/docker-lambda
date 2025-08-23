FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/dotnet6/7c542223679475610ced89f70d9a60546cd6b1b63a1f217c9bff37f86db040af.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/dotnet6/fbc93549ced9fe9bdb4a00b980229e29ff2d430e932884f71965a289c4972285.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2.2025.08.15

# Run: docker run --rm --entrypoint dotnet ghcr.io/shogo82148/lambda-dotnetcore:6 --info
# Check https://dotnet.microsoft.com/en-us/download/dotnet/6.0 for versions
ENV DOTNET_ROOT=/var/lang/bin
ENV PATH=/root/.dotnet/tools:$DOTNET_ROOT:$PATH \
  LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
  AWS_EXECUTION_ENV=AWS_Lambda_dotnet6 \
  DOTNET_SDK_VERSION=6.0.200 \
  DOTNET_CLI_TELEMETRY_OPTOUT=1 \
  NUGET_XMLDOC_MODE=skip

COPY --from=0 /var /var

RUN curl -L https://dot.net/v1/dotnet-install.sh | bash -s -- -v $DOTNET_SDK_VERSION -i $DOTNET_ROOT && \
  mkdir /tmp/warmup && \
  cd /tmp/warmup && \
  dotnet new && \
  cd / && \
  rm -rf /tmp/warmup /tmp/NuGetScratch /tmp/.dotnet

CMD ["dotnet", "build"]
