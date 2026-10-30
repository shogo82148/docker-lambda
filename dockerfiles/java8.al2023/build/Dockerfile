FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8.al2023/4278d4bbaadf22fa44b47d53035bd1c427d0bdf54885b0725a94b955777f398c.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java8.al2023/bc75a3cff18259e6d61e4b72297d6054c008d1f3477d1f5e066e9ce11818e76a.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /


FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.09.26

ENV PATH=/var/lang/bin:$PATH \
  LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
  AWS_EXECUTION_ENV=AWS_Lambda_java8.al2023

COPY --from=0 /var /var

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
  rm -rf /var/lang/* && \
  curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-8-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
  rm -rf /var/lang/*.zip
