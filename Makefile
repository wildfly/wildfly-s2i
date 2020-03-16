IMAGE_VERSION=dev
NAMESPACE=wildfly
IMAGE_NAME=${NAMESPACE}/wildfly-builder
RUNTIME_IMAGE_NAME=${NAMESPACE}/wildfly-runtime
# Include common Makefile code.
include make/common.mk
