# Variables
IMAGE=qt-wasm-builder
BUILD_DIR=build
# Capture current user/group IDs from the host OS
UID=$(shell id -u)
GID=$(shell id -g)

.PHONY: all clean server help

all: ## Build the WebAssembly application (No sudo required)
	@echo "Starting build as User: $(UID), Group: $(GID)..."
	docker run --rm -v $(shell pwd):/project \
		--user $(UID):$(GID) \
		$(IMAGE) \
		/bin/bash -c "source /opt/emsdk/emsdk_env.sh && qt-cmake -S . -B $(BUILD_DIR) -G Ninja && cmake --build $(BUILD_DIR)"
	@echo "Build successful. Files in $(BUILD_DIR)/ are owned by $(shell whoami)."

clean: ## Remove the build directory
	rm -rf $(BUILD_DIR)

server: ## Start the local Python test server
	python3 server.py

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
