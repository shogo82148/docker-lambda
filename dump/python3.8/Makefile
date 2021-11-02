.PHONEY: all
all: dist.zip

dist.zip: dist/index.py
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/index.py: index.py
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
	-rm -f dist.zip
