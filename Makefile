GOCACHE ?= /tmp/nvim-gocache

.PHONY: b64flip-test base64-test test

b64flip-test:
	cd tools/b64flip && GOCACHE=$(GOCACHE) go test ./...

base64-test:
	NVIM_APPNAME=base64-test nvim --headless --clean -u tests/minimal_init.lua -c "lua require('tests.base64_spec').run()" -c qa

test: b64flip-test base64-test
