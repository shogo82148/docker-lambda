.PHONY: all
all: build/distributions/app.zip

build/distributions/app.zip: src/main/java/com/shogo82148/lambda/DumpJava11.java build.gradle build.sh
	./build.sh

.PHONY: deploy
deploy: build/distributions/app.zip
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
	-rm -f build
	-rm -f out.json
