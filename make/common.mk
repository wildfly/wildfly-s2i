build = make/build.sh

script_env = \
	IMAGE_NAME=$(IMAGE_NAME) \
        IMAGE_VERSION=$(IMAGE_VERSION) \
        RUNTIME_IMAGE_NAME=$(RUNTIME_IMAGE_NAME) \
        CONTAINER_BUILD_ENGINE=${CONTAINER_BUILD_ENGINE}

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: test
test:
	$(script_env) TEST_MODE=true $(build)
