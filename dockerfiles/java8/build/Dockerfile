FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8/bfa63f3e24f34153e2f02a4bfcf4ce9e7e0a19ea14409076b15da7dfd79c580c.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2024.06.14

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

WORKDIR /

COPY --from=0 /var /var

RUN yum install -y java-1.8.0-openjdk-devel
