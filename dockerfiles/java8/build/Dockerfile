FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8/03e3db31907628c92afca7ff40195afb4ce2768d9772e0a8030c99f987e5c35e.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2024.01.12

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

WORKDIR /

COPY --from=0 /var /var

RUN yum install -y java-1.8.0-openjdk-devel
