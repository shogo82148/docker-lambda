FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

ARG TARGETOS
ARG TARGETARCH

RUN yum install -y tar gzip

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.1

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-base:build-al2.2025.03.07

COPY --from=0 /docker-lambda-init /var/runtime/init
