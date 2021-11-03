package main

import (
	"context"
	"os"
	"os/exec"

	"github.com/aws/aws-lambda-go/lambda"
)

func handleRequest(ctx context.Context, event interface{}) (map[string]interface{}, error) {
	dump, err := exec.LookPath("lambda-dump")
	if err != nil {
		return nil, err
	}
	bucket := os.Getenv("BUCKET")
	cmd := exec.CommandContext(ctx, dump, "-bucket", bucket, "-key", "fs/__ARCH__/go1.x.tgz")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return nil, err
	}

	return map[string]interface{}{}, nil
}

func main() {
	lambda.Start(handleRequest)
}
