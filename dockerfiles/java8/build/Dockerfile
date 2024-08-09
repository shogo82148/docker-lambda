FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8/c7d77fb04afc82a379efef101422ff8c0594765c292c536c73bdaf32744ae4a3.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2024.07.06

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

WORKDIR /

COPY --from=0 /var /var

RUN yum install -y java-1.8.0-openjdk-devel
