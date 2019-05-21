#!/bin/sh
# Openshift WildFly configure and launch script

source $JBOSS_HOME/bin/launch/logging.sh
source ${JBOSS_HOME}/bin/configure-openshift.sh
source ${JBOSS_HOME}/bin/standalone-openshift.sh