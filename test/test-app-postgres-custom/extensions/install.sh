#!/bin/bash
injected_dir=$1
echo RUNNING $JBOSS_HOME/bin/jboss-cli.sh --file=$injected_dir/cli.txt
$JBOSS_HOME/bin/jboss-cli.sh --file=$injected_dir/cli.txt

