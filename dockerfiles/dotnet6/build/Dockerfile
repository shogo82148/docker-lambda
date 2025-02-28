FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/dotnet6/aeb6c0e021bc9c53a809f64213c9ad4ab343e271775aa4d2a0789e1faa291a3d.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/dotnet6/d2547a7a5e46f51d4696c4086650938904a4c47d22fda60913b0738db920ea5b.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2.2025.02.14

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
