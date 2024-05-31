FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8/91a7b118d3eaa42b22e41dce6b70b59aefff7c90d4ca21d29bb93b1e1c7ccc9a.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2024.05.22

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

WORKDIR /

COPY --from=0 /var /var

RUN yum install -y java-1.8.0-openjdk-devel
