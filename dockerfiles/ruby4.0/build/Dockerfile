FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/ruby4.0/40e263d3631d25574423769cfb4f88660070ea8e2cd8a172f0e38cf2ccbe5730.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/ruby4.0/a4133a905c59d370786dedd2d8a5b27bb52f86d0abb58de884fde1ec997a9a2e.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.06.19

ENV PATH=/var/lang/bin:$PATH \
  LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
  AWS_EXECUTION_ENV=AWS_Lambda_ruby4.0

COPY --from=0 /var /var
