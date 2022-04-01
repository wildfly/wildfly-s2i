#!/bin/bash

if [ -n "${TEST_EXTENSION_POST_ADD_PROPERTY}" ]; then
  echo "/system-property=${TEST_EXTENSION_POST_ADD_PROPERTY}:add(value=${TEST_EXTENSION_POST_ADD_PROPERTY})" >> ${CLI_SCRIPT_FILE}
fi

if [ -n "${TEST_EXTENSION_POST_FAIL}" ]; then
  echo "Error ${TEST_EXTENSION_POST_FAIL}" >> ${CONFIG_ERROR_FILE}
fi

if [ -n "${TEST_EXTENSION_POST_CLI_FAIL}" ]; then
   echo "${TEST_EXTENSION_POST_CLI_FAIL}" >> ${CLI_SCRIPT_FILE}
fi

if [ -n "${TEST_EXTENSION_POST_CLI_RESTART}" ]; then
   echo ":server-set-restart-required" >> ${CLI_SCRIPT_FILE}
fi

if [ -n "${TEST_EXTENSION_POST_START_CLI_COMMAND}" ]; then
  ${JBOSS_HOME}/bin/jboss-cli.sh -c ${TEST_EXTENSION_POST_START_CLI_COMMAND}
fi

if [ -n "${TEST_EXTENSION_POST_START_EMBEDDED_CLI_COMMAND}" ]; then
  cli_content="embed-server
    ${TEST_EXTENSION_POST_START_EMBEDDED_CLI_COMMAND}"
  echo "${cli_content}" > /tmp/post-cli.cli
  ${JBOSS_HOME}/bin/jboss-cli.sh --file=/tmp/post-cli.cli
fi