# we just do unzip in this image
# so we use the build platform here.
FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/base.al2023/82dea71fdd4f6828bb45a85e416f90a4ab4ce9905977d57dccd0adb3c86e87ed.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/base.al2023/fb63018ab164bd052b0d17c8e88c88b2f67e90c9d773b264293506b3d83cd9dc.tgz

RUN cd /opt && \
    case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL -o base.al2023.tgz "$ARCHIVE_URL" && \
    tar xzf base.al2023.tgz && rm base.al2023.tgz
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
