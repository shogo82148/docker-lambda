FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java11/e0fbeeaf6ceb1ceef152f8e6ccc765b055ea94075035199f7911ee99ea63232f.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java11/3a2204380e079fc4db1d6588c33fbde4e0f1799ae9b833e469d6162eac8f0ebd.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-al2.2024.01.04

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java11

COPY --from=0 /var /var

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    rm -rf /var/lang/* && \
    curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-11-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
    rm -rf /var/lang/*.zip
