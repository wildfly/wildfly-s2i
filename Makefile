IMAGE_VERSION=dev
NAMESPACE=wildfly
IMAGE_NAME=${NAMESPACE}/wildfly-s2i-jdk11
RUNTIME_IMAGE_NAME=${NAMESPACE}/wildfly-runtime-jdk11
# Include common Makefile code.
include make/common.mk
