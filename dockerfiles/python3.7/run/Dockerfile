FROM public.ecr.aws/amazonlinux/amazonlinux:1

ARG TARGETOS
ARG TARGETARCH

ENV ARCHIVE_URL_AMD64=https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.7/1ee33368966ebb741f602aae1722001dad774b9e18299547b2b875347da4a920.tgz

RUN curl -sSL "$ARCHIVE_URL_AMD64" | tar -zx -C /

ENV DOCKER_LAMBDA_INIT_VERSION=1.0.1

RUN curl -sSL "https://github.com/shogo82148/docker-lambda-init/releases/download/v$DOCKER_LAMBDA_INIT_VERSION/docker-lambda-init_${DOCKER_LAMBDA_INIT_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xzv

FROM ghcr.io/shogo82148/lambda-base:alami.2024.08.09

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.7

RUN rm -rf /var/runtime /var/lang /var/rapid && \
  curl https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.7.tgz | tar -zx -C /

COPY --from=0 /var /var
COPY --from=0 /docker-lambda-init /var/runtime/mockserver

USER sbx_user1051

ENTRYPOINT ["/var/rapid/init", "--bootstrap", "/var/runtime/bootstrap"]
