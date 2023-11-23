FROM public.ecr.aws/shogo82148/lambda-python:3.11

FROM public.ecr.aws/shogo82148/lambda-base:build-al2

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.7 \
    PKG_CONFIG_PATH=/var/lang/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig \
    PIPX_BIN_DIR=/var/lang/bin \
    PIPX_HOME=/var/lang/pipx

COPY --from=0 /var/runtime /var/runtime
COPY --from=0 /var/lang /var/lang
COPY --from=0 /var/rapid /var/rapid
