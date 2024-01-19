FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.0

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2024.01.19

COPY --from=0 /docker-lambda-init /var/runtime/init
