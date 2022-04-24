.PHONEY: all
all: dist.zip

dist.zip: dist/dump_dotnetcore31.dll
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/dump_dotnetcore31.dll: Function.cs dump-dotnetcore31.csproj
	./build.sh

.PHONEY: deploy
deploy: dist.zip
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
	./build.sh

.PHONEY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
	-rm -f out.json
	-rm -rf obj
	-rm -rf bin
