BPFTOOL := /usr/local/bin/bpftool
KERNEL_IMAGE :=

lint:
	cargo clippy --tests
	cargo check --tests

# Build the tests but do not run them.
build-test:
	cargo test --no-run --offline

# Run the tests on the host using sudo
test: build-test
	RUST_TEST_THREADS=1 BPFTOOL_PATH=$(BPFTOOL) sudo -E $(shell which cargo) test --offline

# Run the tests in a vm. Requires danobi/vmtest.
vmtest: build-test
	vmtest -k $(KERNEL_IMAGE) "RUST_TEST_THREADS=1 BPFTOOL_PATH=$(BPFTOOL) cargo test"

clean:
	cargo clean
