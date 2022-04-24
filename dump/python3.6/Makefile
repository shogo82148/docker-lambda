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

.PHONEY: dump
dump:
	./dump.sh x86_64

.PHONEY: test
test:
	bash -n deploy.sh
	bash -n dump.sh

.PHONEY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
