FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

ARG TARGETOS
ARG TARGETARCH

RUN dnf install -y tar gzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/nodejs24.x/73bf355b5781736986ca3e10ecd01d3d141e9dc70ef5acd45eff09d443f173de.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/nodejs24.x/21ada1be790cb85b6c4f56d586570fc062eb6de1a8614273ad41d863c2849b57.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM ghcr.io/shogo82148/lambda-base:build-al2023.2026.04.25

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_nodejs24.x \
    NODE_PATH=/opt/nodejs/node24/node_modules:/opt/nodejs/node_modules:/var/runtime/node_modules

COPY --from=0 /var /var
