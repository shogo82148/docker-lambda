#!/bin/sh

set -uex

cd "$(dirname "$0")"

curl -s https://shogo82148-docker-lambda.s3.amazonaws.com/fs/x86_64/java8.tgz | tar -zx -- var/runtime/lib

mv var/runtime/lib/LambdaSandboxJava-byol.jar var/runtime/lib/gson-*.jar ./

mkdir -p ./target/classes

javac -target 1.8 -cp ./gson-*.jar -d ./target/classes ./src/main/java/lambdainternal/LambdaRuntime.java

cp -R ./target/classes/lambdainternal ./

jar uf LambdaSandboxJava-byol.jar lambdainternal/LambdaRuntime*.class

rm -rf ./var ./lambdainternal
