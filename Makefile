GOCACHE ?= /tmp/nvim-gocache

.PHONY: nvim-helper-test base64-test test

nvim-helper-test:
	cd tools/nvim-helper && GOCACHE=$(GOCACHE) go test ./...

base64-test:
	NVIM_APPNAME=base64-test nvim --headless --clean -u tests/minimal_init.lua -c "lua require('tests.base64_spec').run()" -c qa

test: nvim-helper-test base64-test
