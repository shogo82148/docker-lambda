FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/ruby2.7/b075324cc3e8d4afb72d6e5f6b77e09ddacd3cf63cd7e6f85da2a1df6c4aced3.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/ruby2.7/99b869a91d2dd0b5b16c126953dc9ab14d37e486624d57f6864d6ec682b6d12f.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
  curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM public.ecr.aws/shogo82148/lambda-base:build-al2.2023.12.08

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_ruby2.7

COPY --from=0 /var /var
