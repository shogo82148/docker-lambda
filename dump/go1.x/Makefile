.PHONY: all
all: dist.zip

dist.zip: dist/index
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/index: dump.go go.mod go.sum
	mkdir -p dist
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist/index dump.go

.PHONY: deploy
deploy: dist.zip
	./deploy.sh x86_64

.PHONY: dump
dump:
	./dump.sh x86_64

.PHONY: test
test:
	bash -n deploy.sh
	bash -n dump.sh
	go test ./...

.PHONY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
