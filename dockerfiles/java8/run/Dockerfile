FROM openjdk:8-alpine
WORKDIR /src
COPY ./lambda-runtime-mock /src
RUN apk add --no-cache curl && ./build.sh


FROM public.ecr.aws/shogo82148/lambda-provided:alami

FROM public.ecr.aws/shogo82148/lambda-base:alami

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

RUN rm -rf /var/runtime /var/lang && \
  curl https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8.tgz | tar -zx -C /

COPY --from=0 /src/LambdaSandboxJava-byol.jar /var/runtime/lib/

COPY --from=1 /var/runtime/init /var/runtime/mockserver

WORKDIR /

USER sbx_user1051

ENTRYPOINT ["/usr/bin/java", "-XX:MaxHeapSize=2834432k", "-XX:MaxMetaspaceSize=163840k", "-XX:ReservedCodeCacheSize=81920k", \
  "-XX:+UseSerialGC", "-Xshare:on", "-XX:-TieredCompilation", "-Djava.net.preferIPv4Stack=true", \
  "-jar", "/var/runtime/lib/LambdaJavaRTEntry-byol.jar"]
