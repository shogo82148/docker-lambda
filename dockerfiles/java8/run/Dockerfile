FROM openjdk:8-alpine
WORKDIR /src
COPY ./lambda-runtime-mock /src
RUN apk add --no-cache curl && ./build.sh


FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8/c7d77fb04afc82a379efef101422ff8c0594765c292c536c73bdaf32744ae4a3.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.1

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv


FROM ghcr.io/shogo82148/lambda-base:alami.2024.08.09

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

COPY --from=0 /src/LambdaSandboxJava-byol.jar /var/runtime/lib/

COPY --from=1 /var /var
COPY --from=1 /docker-lambda-init /var/runtime/mockserver

WORKDIR /

USER sbx_user1051

ENTRYPOINT ["/usr/bin/java", "-XX:MaxHeapSize=2834432k", "-XX:MaxMetaspaceSize=163840k", "-XX:ReservedCodeCacheSize=81920k", \
  "-XX:+UseSerialGC", "-Xshare:on", "-XX:-TieredCompilation", "-Djava.net.preferIPv4Stack=true", \
  "-jar", "/var/runtime/lib/LambdaJavaRTEntry-byol.jar"]
