.PHONEY: all
all: dist_x86_64.zip dist_arm64.zip

dist_x86_64.zip: dist_x86_64/bootstrap
	mkdir -p dist_x86_64
	cd dist_x86_64 && zip -r ../dist_x86_64.zip . -x ".*"

dist_x86_64/bootstrap: dump.go go.mod go.sum
	mkdir -p dist_x86_64
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist_x86_64/bootstrap dump.go

dist_arm64.zip: dist_arm64/bootstrap
	mkdir -p dist_arm64
	cd dist_arm64 && zip -r ../dist_arm64.zip . -x ".*"

dist_arm64/bootstrap: dump.go go.mod go.sum
	mkdir -p dist_arm64
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o dist_arm64/bootstrap dump.go

.PHONEY: deploy
deploy: dist_x86_64.zip dist_arm64.zip
	./deploy.sh x86_64
	./deploy.sh arm64

.PHONEY: dump
dump:
	./dump.sh x86_64
	./dump.sh arm64

.PHONEY: test
test:
	bash -n deploy.sh
	bash -n dump.sh
	go test ./...

.PHONEY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
