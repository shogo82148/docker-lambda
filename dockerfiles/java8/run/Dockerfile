FROM openjdk:17-alpine
WORKDIR /src
COPY ./lambda-runtime-mock /src
RUN apk add --no-cache curl && ./build.sh


FROM public.ecr.aws/shogo82148/lambda-provided:alami

FROM public.ecr.aws/shogo82148/lambda-base:alami

ENV AWS_EXECUTION_ENV=AWS_Lambda_java8

ENV ARCHIVE_URL_AMD64="https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8/af0718a56ed4aa91e036e4319e85bde41ada855141e50966446d4113c815d55f.tgz"

RUN rm -rf /var/runtime /var/lang && \
  curl "$ARCHIVE_URL_AMD64" | tar -zx -C /

COPY --from=0 /src/LambdaSandboxJava-byol.jar /var/runtime/lib/

COPY --from=1 /var/runtime/init /var/runtime/mockserver

WORKDIR /

USER sbx_user1051

ENTRYPOINT ["/usr/bin/java", "-XX:MaxHeapSize=2834432k", "-XX:MaxMetaspaceSize=163840k", "-XX:ReservedCodeCacheSize=81920k", \
  "-XX:+UseSerialGC", "-Xshare:on", "-XX:-TieredCompilation", "-Djava.net.preferIPv4Stack=true", \
  "-jar", "/var/runtime/lib/LambdaJavaRTEntry-byol.jar"]
