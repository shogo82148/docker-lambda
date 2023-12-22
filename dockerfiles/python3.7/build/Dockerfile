FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.7/99e15db2d4f98fd14ec3fbaa9d1531393ae326c26f3064ac1132c2be6250754e.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2023.12.12

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.7 \
    PKG_CONFIG_PATH=/var/lang/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig \
    PIPX_BIN_DIR=/var/lang/bin \
    PIPX_HOME=/var/lang/pipx

COPY --from=0 /var /var
