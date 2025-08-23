FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/dotnet6/7c542223679475610ced89f70d9a60546cd6b1b63a1f217c9bff37f86db040af.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/dotnet6/fbc93549ced9fe9bdb4a00b980229e29ff2d430e932884f71965a289c4972285.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.1

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-provided:al2

FROM ghcr.io/shogo82148/lambda-base:al2.2025.08.15

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_dotnet6

COPY --from=0 /var /var
COPY --from=0 /docker-lambda-init /var/rapid/init

USER sbx_user1051

ENTRYPOINT ["/var/rapid/init", "--bootstrap", "/var/runtime/bootstrap", "--enable-msg-logs"]
