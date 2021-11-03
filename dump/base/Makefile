.PHONEY: all
all: dist.zip

dist.zip: dist/bootstrap
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/bootstrap: bootstrap
	mkdir -p dist
	cp $< $@

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
	-rm out.json
