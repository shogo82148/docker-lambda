FROM ghcr.io/shogo82148/lambda-provided:alami


FROM ghcr.io/shogo82148/lambda-base:alami

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.6

RUN rm -rf /var/runtime /var/lang && \
  curl https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.6.tgz | tar -zx -C /

COPY runtime_mock.py /var/runtime/awslambda/runtime.py

COPY --from=0 /var/runtime/init /var/runtime/mockserver

USER sbx_user1051

ENTRYPOINT ["/var/lang/bin/python3.6", "/var/runtime/awslambda/bootstrap.py"]
