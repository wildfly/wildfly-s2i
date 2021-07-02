IMAGE_VERSION=dev
NAMESPACE=wildfly
IMAGE_NAME=${NAMESPACE}/wildfly-s2i-jdk11
RUNTIME_IMAGE_NAME=${NAMESPACE}/wildfly-runtime-jre11
# Include common Makefile code.
include make/common.mk
