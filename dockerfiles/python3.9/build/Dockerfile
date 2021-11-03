FROM public.ecr.aws/shogo82148/lambda-base:build-al2

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.9

RUN case $(uname -m) in "x86_64") ARCH=x86_64;; "aarch64") ARCH=arm64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    curl -sSL "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$ARCH/python3.9.tgz" | tar -zx -C /
