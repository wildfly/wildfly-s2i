#!/bin/bash -e
SCRIPT_DIR=$(dirname $0)
pushd ${SCRIPT_DIR}/../wildfly-runtime-image
cekit -v build docker
popd
pushd ${SCRIPT_DIR}/../wildfly-builder-image
cekit -v build docker
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