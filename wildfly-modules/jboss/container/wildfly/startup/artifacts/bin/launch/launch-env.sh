#!/bin/sh
# Openshift WildFly execution environment setup

# Scripts that modify the runtime environment variables.
# wildfly-cekit-modules will look for each of the listed files and run them if they exist.
ENV_SCRIPT_CANDIDATES=(
  /opt/run-java/proxy-options
  $JBOSS_HOME/bin/launch/jboss_modules_system_pkgs.sh
)
