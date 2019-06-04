#!/bin/sh
# Openshift WildFly launch script

source $JBOSS_HOME/bin/launch/logging.sh

# Run modules that can update ENV var
function updateServerEnv() {
  source ${JBOSS_HOME}/bin/launch/launch-env.sh
  source $JBOSS_HOME/bin/launch/openshift-common.sh
  source ${JBOSS_HOME}/bin/launch/openshift-env-modules.sh
  source $JBOSS_HOME/bin/launch/configure-modules.sh
  configureEnvModules
}

# TERM signal handler
function clean_shutdown() {
  log_error "*** WildFly wrapper process ($$) received TERM signal ***"
  $JBOSS_HOME/bin/jboss-cli.sh -c "shutdown --timeout=60"
  wait $!
}

updateServerEnv

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
