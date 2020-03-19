function run_cli_script(){
  if [ $# != 1 ]; then
    echo "Usage: Script file parameter required."
    return
  fi

  local cli_script=$1

  if [ ! -f "${cli_script}" ]; then
    echo "run_cli_script: Script file parameter "${cli_script}" does not exit."
    return
  fi

  createConfigExecutionContext
  exec_cli_scripts "${cli_script}"
}