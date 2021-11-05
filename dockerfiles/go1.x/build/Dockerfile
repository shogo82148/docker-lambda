FROM public.ecr.aws/shogo82148/lambda-go:1

FROM public.ecr.aws/shogo82148/lambda-base:build-alami

# https://golang.org/doc/devel/release.html
ENV GOLANG_VERSION=1.17.3 \
    GOPATH=/go \
    PATH=/go/bin:/usr/local/go/bin:$PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_go1.x

WORKDIR /go/src/handler

COPY --from=0 /var/runtime /var/runtime
COPY --from=0 /var/lang /var/lang
COPY --from=0 /var/rapid /var/rapid

RUN curl https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -zx -C /usr/local
