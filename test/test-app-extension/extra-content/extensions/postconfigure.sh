#!/bin/bash

if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    echo "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi
${JBOSS_HOME}/bin/jboss-cli.sh --file=$JBOSS_HOME/extensions/extension.cli
