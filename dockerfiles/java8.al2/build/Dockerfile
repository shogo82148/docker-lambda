FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64="https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8.al2/13f9ead71de11d6a6312e8c10ed1a332e643b19b12859981ab6e50b23a8ebadf.tgz"
ENV ARCHIVE_URL_ARM64="https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java8.al2/085889ccac4b8e5cfc8f89fcafa92c8fb551dab28bc463aa8873d338d1151b0e.tgz"

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

FROM public.ecr.aws/shogo82148/lambda-base:build-al2

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java8.al2

COPY --from=0 /var /var

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    rm -rf /var/lang/* && \
    curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-8-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
    rm -rf /var/lang/*.zip && \
    mkdir /usr/local/gradle && curl -L -o gradle.zip https://services.gradle.org/distributions/gradle-7.3.3-bin.zip && \
    unzip -qd /usr/local/gradle gradle.zip && rm gradle.zip && mkdir /usr/local/maven && \
    curl -L https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz | \
    tar -zx -C /usr/local/maven

ENV PATH="/usr/local/gradle/gradle-7.3.3/bin:/usr/local/maven/apache-maven-3.8.4/bin:${PATH}"
