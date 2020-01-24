#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/usr/local/s2i/*

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

# Legacy location
ln -s /usr/local/s2i /usr/libexec/s2i

chmod ugo+x /opt/jboss/container/wildfly/s2i/install-common/install-common-overrides.sh
ln -s /opt/jboss/container/wildfly/s2i/install-common/install-common-overrides.sh /usr/local/s2i/install-common-overrides.sh
chown -h jboss:root /usr/local/s2i/install-common-overrides.sh