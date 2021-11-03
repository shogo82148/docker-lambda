.PHONEY: all
all: dist.zip

dist.zip: dist/index
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/index: dump.go go.mod go.sum
	mkdir -p dist
	GOOS=linux GOARCH=amd64 go build -o dist/index dump.go

.PHONEY: deploy
deploy: dist.zip
	./deploy.sh x86_64

.PHONEY: dump
dump:
	./dump.sh x86_64

.PHONEY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
