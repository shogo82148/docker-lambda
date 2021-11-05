FROM public.ecr.aws/shogo82148/lambda-provided:alami


FROM public.ecr.aws/shogo82148/lambda-base:alami

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_python3.7

RUN rm -rf /var/runtime /var/lang /var/rapid && \
  curl https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/python3.7.tgz | tar -zx -C /

COPY --from=0 /var/runtime/init /var/rapid/init

USER sbx_user1051

ENTRYPOINT ["/var/rapid/init", "--bootstrap", "/var/runtime/bootstrap"]
