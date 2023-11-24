# Go is easy to run cross platform build,
# so we use native platform here
FROM --platform=$BUILDPLATFORM golang:1
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY aws-lambda-mock.go ./

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=${TARGETOS} go build aws-lambda-mock.go

FROM public.ecr.aws/shogo82148/lambda-provided:alami

FROM public.ecr.aws/shogo82148/lambda-base:alami

ENV AWS_EXECUTION_ENV=AWS_Lambda_go1.x

ENV ARCHIVE_URL_AMD64="https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/go1.x/80ae8b551111acd4a7cfdddc014728c85d9680b8ce2ea8c9bb701026ef50037e.tgz"

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /

COPY --from=0 /app/aws-lambda-mock /var/runtime/aws-lambda-go

COPY --from=1 /var/runtime/init /var/runtime/mockserver

USER sbx_user1051

ENTRYPOINT ["/var/runtime/aws-lambda-go"]
