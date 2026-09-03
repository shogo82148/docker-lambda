FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2027

RUN dnf install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java17.al2023/7d97c9f4443e705d4a2f30a5097489bba4a13d3c3bcbbe04bc48f33356b8da9f.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java17.al2023/384e183e34ce40ec4e0d654af9e97338a0f1f7db97d11700c03160e54e5bba70.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /


FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.08.28

ENV PATH=/var/lang/bin:$PATH \
  LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
  AWS_EXECUTION_ENV=AWS_Lambda_java17.al2023

COPY --from=0 /var /var

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
  rm -rf /var/lang/* && \
  curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-17-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
  rm -rf /var/lang/*.zip
