#!/bin/bash -e

# use CONTAINER_BUILD_ENGINE=docker if you want to use docker to build
CONTAINER_BUILD_ENGINE=${CONTAINER_BUILD_ENGINE:-docker}

SCRIPT_DIR=$(dirname $0)
pushd ${SCRIPT_DIR}/../wildfly-runtime-image
cekit build ${CONTAINER_BUILD_ENGINE}
popd
pushd ${SCRIPT_DIR}/../wildfly-builder-image
cekit build ${CONTAINER_BUILD_ENGINE}
popd

if [[ ! -z "${TEST_MODE:-}" ]]; then
  pushd ${SCRIPT_DIR}/../wildfly-builder-image
  cekit test behave
  if [ $? -ne 0 ]; then
    echo "cekit test behave failed."
    exit 1
  fi
  popd
  ${SCRIPT_DIR}/../test/run
fi