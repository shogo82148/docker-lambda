FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

ARG TARGETOS
ARG TARGETARCH

RUN dnf install -y tar gzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java25/367b3492d4a740068ae35514b201ed7cf3eb8fc6562369b4c07f9a53c9568956.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java25/685f6edb7898a23a5bc6f8ad249eb3a5e0cd39c9b2209528dcaf44a711f26315.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.09.26

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java25

COPY --from=0 /var /var

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    rm -rf /var/lang/* && \
    curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-21-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
    rm -rf /var/lang/*.zip
