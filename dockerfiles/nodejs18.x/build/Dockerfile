FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/nodejs18.x/c837ff0545a967176bedc7dad49d301ce729467890ac8a74f32df82c07d94749.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/nodejs18.x/a7a1916e4ca93d44fe07af7e439de7d116f62433fc0b827b16fdd609feceec39.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2.2025.01.01

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_nodejs18.x \
    NODE_PATH=/opt/nodejs/node16/node_modules:/opt/nodejs/node_modules:/var/runtime/node_modules

COPY --from=0 /var /var
