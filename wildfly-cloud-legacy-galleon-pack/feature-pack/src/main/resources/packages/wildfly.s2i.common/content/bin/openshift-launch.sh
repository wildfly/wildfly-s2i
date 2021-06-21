#!/usr/bin/env bash

echo "`date "+%Y-%m-%d %H:%M:%S"` Launching WildFly Server"

# Always start sourcing the launch script supplied by wildfly-cekit-modules
source ${JBOSS_HOME}/bin/launch/launch.sh

PUBLIC_IP_ADDRESS=${WILDFLY_PUBLIC_BIND_ADDRESS:-$(hostname -i)}
MANAGEMENT_IP_ADDRESS=${WILDFLY_MANAGEMENT_BIND_ADDRESS:-0.0.0.0}
ENABLE_STATISTICS=${WILDFLY_ENABLE_STATISTICS:-true}

launchServer "$JBOSS_HOME/bin/standalone.sh -c $SERVER_CONFIG -b ${PUBLIC_IP_ADDRESS} -bmanagement ${MANAGEMENT_IP_ADDRESS} -Dwildfly.statistics-enabled=${ENABLE_STATISTICS}"