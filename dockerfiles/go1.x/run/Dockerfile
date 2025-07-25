# Go is easy to run cross platform build,
# so we use native platform here
FROM --platform=$BUILDPLATFORM golang:1.24.5
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY aws-lambda-mock.go ./

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=${TARGETOS} go build aws-lambda-mock.go

FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/go1.x/93f0659a50493c7c5d69c0720b335681f26bb27fade0a634d2b605b5dce10ceb.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.1

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-base:alami.2024.08.09

ENV AWS_EXECUTION_ENV=AWS_Lambda_go1.x

COPY --from=0 /app/aws-lambda-mock /var/runtime/aws-lambda-go

COPY --from=1 /var /var
COPY --from=1 /docker-lambda-init /var/runtime/mockserver

USER sbx_user1051

ENTRYPOINT ["/var/runtime/aws-lambda-go"]
