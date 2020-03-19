#!/bin/sh
# Openshift WildFly runtime configuration update
# Centralised configuration file to set variables that affect the launch scripts in wildfly-cekit-modules.

# Scripts that 
# wildfly-cekit-modules will look for each of the listed files and run them if they exist.
CONFIG_SCRIPT_CANDIDATES=(
  # Must be the first one.
  $JBOSS_HOME/bin/launch/configure_extensions.sh
  $JBOSS_HOME/bin/launch/admin.sh
  $JBOSS_HOME/bin/launch/access_log_valve.sh
  $JBOSS_HOME/bin/launch/configure_logger_category.sh
  $JBOSS_HOME/bin/launch/datasource.sh
  $JBOSS_HOME/bin/launch/deploymentScanner.sh
  $JBOSS_HOME/bin/launch/elytron.sh
  $JBOSS_HOME/bin/launch/filters.sh
  $JBOSS_HOME/bin/launch/https.sh
  $JBOSS_HOME/bin/launch/jgroups.sh
  $JBOSS_HOME/bin/launch/ha.sh
  $JBOSS_HOME/bin/launch/json_logging.sh
  $JBOSS_HOME/bin/launch/keycloak.sh
  $JBOSS_HOME/bin/launch/mp-config.sh
  $JBOSS_HOME/bin/launch/mysql.sh
  $JBOSS_HOME/bin/launch/ports.sh
  $JBOSS_HOME/bin/launch/postgresql.sh
  $JBOSS_HOME/bin/launch/resource-adapter.sh
  $JBOSS_HOME/bin/launch/tracing.sh
  /opt/run-java/proxy-options
  $JBOSS_HOME/bin/launch/jboss_modules_system_pkgs.sh
  $JBOSS_HOME/bin/launch/statefulset.sh
)

# Notice that the value of this variable must be aligned with the value configured in assemble
export CONFIG_ADJUSTMENT_MODE="cli"
if [ -z "${DISABLE_GENERATE_DEFAULT_DATASOURCE}" ] ; then
  DISABLE_GENERATE_DEFAULT_DATASOURCE=true
fi
