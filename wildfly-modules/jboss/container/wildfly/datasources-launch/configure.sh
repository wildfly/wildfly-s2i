#!/bin/sh
# Openshift 
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

# Add custom packages
cp -r ${ARTIFACTS_DIR}/* ${JBOSS_CONTAINER_WILDFLY_GALLEON_FP_PACKAGES}