#!/usr/bin/env bash
injected_dir=$1
source /usr/local/s2i/install-common.sh

S2I_CLI_SCRIPT="${injected_dir}/configuration.cli"

echo "/system-property=prop-s2i-one:add(value=prop-s2i-one-value)" > "${S2I_CLI_SCRIPT}"
echo "/system-property=prop-s2i-two:add(value=prop-s2i-two-value)" >> "${S2I_CLI_SCRIPT}"
run_cli_script "${S2I_CLI_SCRIPT}"

echo "/system-property=prop-my-env:add(value=${MY_ENVIRONMENT_CONFIGURATION})" > "${S2I_CLI_SCRIPT}"
run_cli_script "${S2I_CLI_SCRIPT}"
