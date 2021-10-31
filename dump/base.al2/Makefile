.PHONEY: all
all: dist.zip

dist.zip: dist/index.js
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/index.js: index.js
	mkdir -p dist
	cp $< $@

.PHONEY: deploy
deploy: dist.zip
	./deploy.sh x86_64
	./deploy.sh arm64

.PHONEY: dump
dump:
	./dump.sh x86_64
	./dump.sh arm64

.PHONEY: clean
clean:
	-rm -rf dist
