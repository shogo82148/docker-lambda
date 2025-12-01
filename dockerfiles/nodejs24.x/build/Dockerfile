FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

ARG TARGETOS
ARG TARGETARCH

RUN dnf install -y tar gzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/nodejs24.x/e4dca11354e493e74bce22c2b5d6dbc715b9ed9ee67505e76a25afd4e221ac41.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/nodejs24.x/b11f4ac8e1485e4c137ff9927cdc6a786070c0bd63cac0f8de0b4d351dae1fe6.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2023.2025.11.24

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_nodejs24.x \
    NODE_PATH=/opt/nodejs/node24/node_modules:/opt/nodejs/node_modules:/var/runtime/node_modules

COPY --from=0 /var /var
