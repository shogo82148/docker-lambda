.PHONEY: all
all: build/distributions/app.zip

build/distributions/app.zip: src/main/java/com/shogo82148/lambda/DumpJava8.java build.gradle build.sh
	./build.sh

.PHONEY: deploy
deploy: build/distributions/app.zip
	./deploy.sh x86_64
	./deploy.sh arm64

.PHONEY: dump
dump:
	./dump.sh x86_64
	./dump.sh arm64

.PHONEY: clean
clean:
	-rm -f build
	-rm -f out.json
