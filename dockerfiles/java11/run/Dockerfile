FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java11/68de34b86a0a7fff1518040433b5ecf9196fec774dc1631579df947e205ed8dd.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java11/76c7e8a445bba29d9be4688dc2262d5a54df2903aaf241fbc4eeae1bfc49a63c.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.3

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-base:al2.2026.02.20

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java11

COPY --from=0 /var /var
COPY --from=0 /docker-lambda-init /var/rapid/init

# The published fs tarball normalises every file mtime to epoch 0 for
# reproducible hashes (see dump/layer/main.go), invalidating the AppCDS archive
# the managed runtime ships in runtime.jsa: it records each classpath jar's
# original mtime, so the bootstrap's forced -Xshare:on refuses to map it
# ("timestamp has changed") and the JVM aborts before it starts. JDK 11 predates
# dynamic CDS, so dump a static archive from a class list. No-op once it maps.
RUN CP=$(java -Xshare:on -XX:SharedArchiveFile=/var/lang/lib/server/runtime.jsa -Xlog:class+path=info -version 2>&1 | sed -n 's/.*Expecting -Djava.class.path=//p' | grep -m1 . || true) && \
    if [ -n "$CP" ]; then \
        java -XX:DumpLoadedClassList=/tmp/classes.lst -cp "$CP" -version >/dev/null 2>&1 && \
        java -Xshare:dump -XX:SharedClassListFile=/tmp/classes.lst -XX:SharedArchiveFile=/var/lang/lib/server/runtime.jsa -cp "$CP" >/dev/null 2>&1 && \
        rm -f /tmp/classes.lst && \
        java -Xshare:on -XX:SharedArchiveFile=/var/lang/lib/server/runtime.jsa -cp "$CP" -version >/dev/null; \
    fi

USER sbx_user1051

ENTRYPOINT ["/var/rapid/init", "--bootstrap", "/var/runtime/bootstrap", "--enable-msg-logs"]
