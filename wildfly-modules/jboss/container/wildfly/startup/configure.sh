#!/bin/sh
# Openshift 
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

# Add custom startup scripts
mkdir -p ${JBOSS_HOME}/bin
cp -r ${ARTIFACTS_DIR}/* ${JBOSS_HOME}