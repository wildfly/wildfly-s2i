#!/usr/bin/env bash

# Always start sourcing the launch script supplied by wildfly-cekit-modules
source ${JBOSS_HOME}/bin/launch/launch.sh

# TERM signal handler
function clean_shutdown() {
  log_error "*** WildFly wrapper process ($$) received TERM signal ***"
  $JBOSS_HOME/bin/jboss-cli.sh -c "shutdown --timeout=60"
  wait $!
}

# exposed by wildfly-cekit-modules
configure_server

log_info "Running $IMAGE_NAME image, version $IMAGE_VERSION"

trap "clean_shutdown" TERM
trap "clean_shutdown" INT

if [ -n "$CLI_GRACEFUL_SHUTDOWN" ] ; then
  trap "" TERM
  log_info "Using CLI Graceful Shutdown instead of TERM signal"
fi

PUBLIC_IP_ADDRESS=${WILDFLY_PUBLIC_BIND_ADDRESS:-$(hostname -i)}
MANAGEMENT_IP_ADDRESS=${WILDFLY_MANAGEMENT_BIND_ADDRESS:-0.0.0.0}
ENABLE_STATISTICS=${WILDFLY_ENABLE_STATISTICS:-true}

$JBOSS_HOME/bin/standalone.sh -c $SERVER_CONFIG -b ${PUBLIC_IP_ADDRESS} -bmanagement ${MANAGEMENT_IP_ADDRESS} -Dwildfly.statistics-enabled=${ENABLE_STATISTICS} &

PID=$!
wait $PID 2>/dev/null
wait $PID 2>/dev/null