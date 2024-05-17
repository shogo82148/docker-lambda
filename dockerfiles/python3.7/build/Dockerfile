FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.7/a2a1bb24b11c3321aeced9b0784b54842fe1cec8c1f2864bbf70a7e15909848f.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /


FROM public.ecr.aws/shogo82148/lambda-base:build-alami.2024.05.07

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.7 \
    PKG_CONFIG_PATH=/var/lang/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig \
    PIPX_BIN_DIR=/var/lang/bin \
    PIPX_HOME=/var/lang/pipx

COPY --from=0 /var /var
