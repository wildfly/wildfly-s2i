#!/bin/bash -e
SCRIPT_DIR=$(dirname $0)
pushd ${SCRIPT_DIR}/../wildfly-runtime-image
cekit build docker
popd
pushd ${SCRIPT_DIR}/../wildfly-builder-image
cekit build docker
popd

if [[ ! -z "${TEST_MODE:-}" ]]; then
  ${SCRIPT_DIR}/../test/run
fi