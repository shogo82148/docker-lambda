FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

ARG TARGETOS
ARG TARGETARCH

RUN dnf install -y tar gzip

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/nodejs20.x/b2d7677ea6d479ddc3b046728efb6e7cfe0461c8243f4d353f0d08b3a427572d.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/nodejs20.x/2ec83ece929a9ecf49696d652a1f96bb8a842753697e4e00cfddaf1d1c4587ec.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM public.ecr.aws/shogo82148/lambda-base:build-al2023.2024.05.22

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_nodejs20.x \
    NODE_PATH=/opt/nodejs/node16/node_modules:/opt/nodejs/node_modules:/var/runtime/node_modules

COPY --from=0 /var /var
