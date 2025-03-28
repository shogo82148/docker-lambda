FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.11/5757e0e6c4ee8f98e917e9981b8fa18c427e0256e5035be6ee73c72abe260908.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/python3.11/88a58a25196d6a9f0203eeb1aa3c8838392c4cca776dc91d971afd13a6b1cf52.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2.2025.03.28

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.11

COPY --from=0 /var /var
