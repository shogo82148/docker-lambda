# Go is easy to run cross platform build,
# so we use native platform here
FROM --platform=$BUILDPLATFORM golang:1
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY init.go ./

ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 GOARCH=${TARGETARCH} GOOS=${TARGETOS} go build -o init init.go


FROM public.ecr.aws/shogo82148/lambda-base:al2023

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH

COPY --from=0 /app/init /var/runtime/init

USER sbx_user1051

ENTRYPOINT ["/var/runtime/init"]
