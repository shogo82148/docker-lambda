FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

ARG TARGETOS
ARG TARGETARCH

RUN yum install -y tar gzip

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.2

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-base:al2.2026.02.20

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH

COPY --from=0 /docker-lambda-init /var/runtime/init

USER sbx_user1051

ENTRYPOINT ["/var/runtime/init"]
