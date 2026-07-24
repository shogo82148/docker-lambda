FROM --platform=$BUILDPLATFORM public.ecr.aws/amazonlinux/amazonlinux:2

RUN yum install -y tar gzip

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java17/238567438e58378b9ff21a3ca0dc2b09a11e928778432aa3247f1e4042e7cef5.tgz
ENV ARCHIVE_URL_ARM64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/arm64/java17/439734cb138d287944ae439839e46eb2ba1505aa4cd811eed897627a9e131503.tgz

RUN case ${TARGETARCH} in "amd64") ARCHIVE_URL=$ARCHIVE_URL_AMD64;; "arm64") ARCHIVE_URL=$ARCHIVE_URL_ARM64;; *) echo "unknown architecture:" ${TARGETARCH}; exit 1;; esac && \
    curl -sSL "$ARCHIVE_URL" | tar -zx -C /

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.3

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-base:al2.2026.02.20

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java17

COPY --from=0 /var /var
COPY --from=0 /docker-lambda-init /var/rapid/init

# The published fs tarball normalises every file mtime to epoch 0 for
# reproducible hashes (see dump/layer/main.go), invalidating the AppCDS archive
# the managed runtime ships in runtime.jsa: it records each classpath jar's
# original mtime, so the bootstrap's forced -Xshare:on refuses to map it
# ("timestamp has changed") and the JVM aborts before it starts. Regenerate it
# against the shipped jars. No-op once the archive maps (CP comes back empty).
RUN CP=$(java -Xshare:on -XX:SharedArchiveFile=/var/lang/lib/server/runtime.jsa -Xlog:class+path=info -version 2>&1 | sed -n 's/.*Expecting -Djava.class.path=//p' | grep -m1 . || true) && \
    if [ -n "$CP" ]; then \
        java -XX:ArchiveClassesAtExit=/var/lang/lib/server/runtime.jsa -cp "$CP" -version >/dev/null 2>&1 && \
        java -Xshare:on -XX:SharedArchiveFile=/var/lang/lib/server/runtime.jsa -cp "$CP" -version >/dev/null; \
    fi

USER sbx_user1051

ENTRYPOINT ["/var/rapid/init", "--bootstrap", "/var/runtime/bootstrap", "--enable-msg-logs"]
