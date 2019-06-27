#!/bin/sh
# Configure module
set -e
SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

# Create empty JBOSS_HOME and bin dir
mkdir -p $JBOSS_HOME/bin

# Add standalone.conf, this is transient until galleon allows to handle it.
cp -r ${ARTIFACTS_DIR}/* ${JBOSS_HOME}