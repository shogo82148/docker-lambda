.PHONY: all
all: dist.zip

dist.zip: dist/dump_dotnet6.dll
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/dump_dotnet6.dll: Function.cs dump-dotnet6.csproj
	./build.sh

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
	./build.sh

.PHONY: clean
clean:
	-rm -rf dist
	-rm -f dist.zip
	-rm -f out.json
	-rm -rf obj
	-rm -rf bin
