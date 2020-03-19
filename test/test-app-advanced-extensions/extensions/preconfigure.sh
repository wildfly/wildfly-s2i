#!/bin/bash

if [ -n "${TEST_EXTENSION_PRE_ADD_PROPERTY}" ]; then
  echo "/system-property=${TEST_EXTENSION_PRE_ADD_PROPERTY}:add(value=${TEST_EXTENSION_PRE_ADD_PROPERTY})" >> ${CLI_SCRIPT_FILE}
fi

if [ -n "${TEST_EXTENSION_PRE_FAIL}" ]; then
  echo "Error ${TEST_EXTENSION_PRE_FAIL}" >> ${CONFIG_ERROR_FILE}
fi

if [ -n "${TEST_EXTENSION_PRE_CLI_FAIL}" ]; then
   echo "${TEST_EXTENSION_PRE_CLI_FAIL}" >> ${CLI_SCRIPT_FILE}
fi

if [ -n "${TEST_EXTENSION_PRE_CLI_RESTART}" ]; then
   echo ":server-set-restart-required" >> ${CLI_SCRIPT_FILE}
fi

if [ -n "${TEST_EXTENSION_PRE_START_CLI_COMMAND}" ]; then
  cli_content="embed-server
    ${TEST_EXTENSION_PRE_START_CLI_COMMAND}"
  echo "${cli_content}" > /tmp/pre-cli.cli
  ${JBOSS_HOME}/bin/jboss-cli.sh --file=/tmp/pre-cli.cli
fi