// Compile with:
// docker run --rm -v "$PWD":/go/src/handler ghcr.io/shogo82148/lambda-go:build-1 sh -c 'go mod download && go build handler.go'

// Run with:
// docker run --rm -v "$PWD":/var/task ghcr.io/shogo82148/lambda-go:1 handler '{"Records": []}'

package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handleRequest(ctx context.Context, event events.S3Event) (string, error) {
	fmt.Println(ctx)

	fmt.Println(event)

	return "Hello World!", nil
}

func main() {
	lambda.Start(handleRequest)
}
