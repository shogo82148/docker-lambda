FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.11/0f32da590b189becbd02cd63979afe305b860729a798f5e6b13dd2745c61bca1.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/python3.11/535b967a74ad25163d5a3ed0d29590520c1a94b887cb4bbac8ec98fdbeb2be33.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2.2025.06.06

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.11

COPY --from=0 /var /var
