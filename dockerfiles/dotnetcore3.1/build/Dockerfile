FROM ghcr.io/shogo82148/lambda-base:build-al2

# Run: docker run --rm --entrypoint dotnet ghcr.io/shogo82148/lambda-dotnetcore:3.1 --info
# Check https://dotnet.microsoft.com/en-us/download/dotnet/3.1 for versions
ENV DOTNET_ROOT=/var/lang/bin
ENV PATH=/root/.dotnet/tools:$DOTNET_ROOT:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_dotnetcore3.1 \
    DOTNET_SDK_VERSION=3.1.416 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    NUGET_XMLDOC_MODE=skip

RUN case $(uname -m) in "x86_64") ARCH=x86_64;; "aarch64") ARCH=arm64;; *) echo "unknown architecture: $(uname -m)"; exit 1;; esac && \
    curl -sSL "https://shogo82148-docker-lambda.s3.amazonaws.com/fs/$ARCH/dotnetcore3.1.tgz" | tar -zx -C /

RUN curl -L https://dot.net/v1/dotnet-install.sh | bash -s -- -v $DOTNET_SDK_VERSION -i $DOTNET_ROOT && \
  mkdir /tmp/warmup && \
  cd /tmp/warmup && \
  dotnet new && \
  cd / && \
  rm -rf /tmp/warmup /tmp/NuGetScratch /tmp/.dotnet

CMD ["dotnet", "build"]
