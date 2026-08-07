.PHONY: all
all: dist.zip

dist.zip: dist/index.py
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/index.py: index.py
	mkdir -p dist
	cp $< $@

.PHONY: deploy
deploy: dist.zip
	./deploy.sh x86_64
	./deploy.sh arm64

.PHONY: dump
dump:
	./dump.sh x86_64
	./dump.sh arm64

.PHONY: test
test:
	bash -n deploy.sh
	bash -n dump.sh

.PHONY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
