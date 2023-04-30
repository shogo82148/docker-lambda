FROM public.ecr.aws/shogo82148/lambda-base:build-al2

ENV PATH=/var/lang/bin:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_java17

RUN case $(uname -m) in "x86_64") ARCH=x86_64;; "aarch64") ARCH=arm64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    curl -sSL "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$ARCH/java17.tgz" | tar -zx -C /

RUN case $(uname -m) in "x86_64") ARCH=x64;; "aarch64") ARCH=aarch64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    rm -rf /var/lang/* && \
    curl -sSL "https://corretto.aws/downloads/latest/amazon-corretto-17-$ARCH-linux-jdk.tar.gz" | tar -xz --strip-components=1 -C /var/lang && \
    rm -rf /var/lang/*.zip && \
    mkdir /usr/local/gradle && curl -L -o gradle.zip https://services.gradle.org/distributions/gradle-8.1.1-bin.zip && \
    unzip -qd /usr/local/gradle gradle.zip && rm gradle.zip && mkdir /usr/local/maven && \
    curl -L https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz | \
    tar -zx -C /usr/local/maven

ENV PATH="/usr/local/gradle/gradle-8.1.1/bin:/usr/local/maven/apache-maven-3.9.1/bin:${PATH}"
