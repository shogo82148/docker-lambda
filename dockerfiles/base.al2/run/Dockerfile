# we just do unzip in this image
# so we use the build platform here.
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y curl tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/base.al2/57b7626fd4fad4385308a5fc73062ca9c46dfbe88d7ec53d58579b3af580c9cf.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/base.al2/3df3539fc91f270f182adec1e70975b116f42e456cb57c7ada1ae6dce43b9fc2.tgz

RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL -o base.al2.tgz "$ARCHIVE_URL" && \
    tar xzf base.al2.tgz && rm base.al2.tgz
RUN mkdir /opt/tmp && chmod 1777 /opt/tmp

FROM scratch

COPY --from=0 /opt /

ENV PATH=/usr/local/bin:/usr/bin/:/bin:/opt/bin \
    LD_LIBRARY_PATH=/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib \
    LANG=en_US.UTF-8 \
    TZ=:UTC \
    LAMBDA_TASK_ROOT=/var/task \
    LAMBDA_RUNTIME_DIR=/var/runtime \
    _LAMBDA_CONTROL_SOCKET=14 \
    _LAMBDA_SHARED_MEM_FD=11 \
    _LAMBDA_LOG_FD=9 \
    _LAMBDA_SB_ID=7 \
    _LAMBDA_CONSOLE_SOCKET=16 \
    _LAMBDA_RUNTIME_LOAD_TIME=1530232235231 \
    _AWS_XRAY_DAEMON_ADDRESS=169.254.79.2 \
    _AWS_XRAY_DAEMON_PORT=2000 \
    AWS_XRAY_DAEMON_ADDRESS=169.254.79.2:2000 \
    AWS_XRAY_CONTEXT_MISSING=LOG_ERROR \
    _X_AMZN_TRACE_ID='Root=1-dc99d00f-c079a84d433534434534ef0d;Parent=91ed514f1e5c03b2;Sampled=1'

WORKDIR /var/task
