.PHONEY: all
all: dist.zip

dist.zip: dist/dump_dotnet6.dll
	mkdir -p dist
	cd dist && zip -r ../dist.zip . -x ".*"

dist/dump_dotnet6.dll: Function.cs dump-dotnet6.csproj
	./build.sh

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
	-rm -f out.json
	-rm -rf obj
	-rm -rf bin
