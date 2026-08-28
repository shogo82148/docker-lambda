FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

ARG TARGETOS
ARG TARGETARCH

RUN dnf install -y tar gzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java21/99be0ddb90faea150169f3fe0f70c7ee7b48262a0707d6a7ab14e715af8e1ba6.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java21/46e8cbe1a0d0eea9204fab62149b10c185d4fcb66456356641db544c81d3a7b5.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.08.15

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java21

COPY --from=0 /var /var

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    rm -rf /var/lang/* && \
    curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-21-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
    rm -rf /var/lang/*.zip
