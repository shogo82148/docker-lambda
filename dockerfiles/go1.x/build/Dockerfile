FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2023.12.22

# https://golang.org/doc/devel/release.html
ENV GOLANG_VERSION=1.21.4 \
    GOPATH=/go \
    PATH=/go/bin:/usr/local/go/bin:$PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_go1.x

WORKDIR /go/src/handler

RUN curl https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -zx -C /usr/local
