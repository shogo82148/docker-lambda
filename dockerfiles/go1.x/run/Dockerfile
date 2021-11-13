FROM golang:1
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY aws-lambda-mock.go ./
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build aws-lambda-mock.go


FROM public.ecr.aws/shogo82148/lambda-provided:alami

FROM public.ecr.aws/shogo82148/lambda-base:alami

ENV AWS_EXECUTION_ENV=AWS_Lambda_go1.x

RUN curl -sSL "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/go1.x.tgz" | tar -zx -C /

COPY --from=0 /app/aws-lambda-mock /var/runtime/aws-lambda-go

COPY --from=1 /var/runtime/init /var/runtime/mockserver

USER sbx_user1051

ENTRYPOINT ["/var/runtime/aws-lambda-go"]
