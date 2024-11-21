.PHONY: all
all: dist/x86_64.zip dist/arm64.zip

dist/x86_64.zip: dist/x86_64/bin/lambda-dump
	mkdir -p dist
	cd dist/x86_64 && zip -r ../x86_64.zip . -x ".*"

dist/x86_64/bin/lambda-dump: main.go go.mod go.sum
	mkdir -p dist/x86_64/bin
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $@ $<

dist/arm64.zip: dist/arm64/bin/lambda-dump
	mkdir -p dist
	cd dist/arm64 && zip -r ../arm64.zip . -x ".*"

dist/arm64/bin/lambda-dump: main.go go.mod go.sum
	mkdir -p dist/arm64/bin
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o $@ $<

.PHONY: deploy
deploy: dist/x86_64.zip dist/arm64.zip
	./deploy.sh x86_64
	./deploy.sh arm64

.PHONY: test
test:
	bash -n deploy.sh
	go test ./...

.PHONY: clean
clean:
	-rm -rf dist
