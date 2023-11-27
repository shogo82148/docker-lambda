FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN yum install -y curl tar gzip
RUN case $(uname -m) in "x86_64") ARCH=x86_64;; "aarch64") ARCH=arm64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    curl -sSL "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$ARCH/java11.tgz" | tar -zx -C /

FROM public.ecr.aws/shogo82148/lambda-provided:al2

FROM public.ecr.aws/shogo82148/lambda-base:al2

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java11

COPY --from=0 /var /var

COPY --from=1 /var/runtime/init /var/rapid/init

USER sbx_user1051

ENTRYPOINT ["/var/rapid/init", "--bootstrap", "/var/runtime/bootstrap", "--enable-msg-logs"]
