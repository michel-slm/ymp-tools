build/src/ymp-install: ./build
	waf build

./build:
	waf configure

clean:
	waf clean

test: build/src/ymp-install
	build/src/ymp-install testdata/osc.ymp
