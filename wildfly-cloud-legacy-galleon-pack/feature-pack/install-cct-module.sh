#!/bin/bash
set -e
# Copy logging.sh file that is expected by launch scripts to be in JBOSS_HOME/bin/launch
SCRIPT_DIR=$(pwd -P)/$(dirname $0)
tmp_dir="$SCRIPT_DIR/target/tmp"
resources_dir="$SCRIPT_DIR/target/resources"
packages_dir="$resources_dir/packages"
common_package_dir="$packages_dir/wildfly.s2i.common/content"

mkdir -p $common_package_dir
mkdir -p $tmp_dir
pushd "$tmp_dir"
  echo "git clone -b $CCT_MODULES_TAG http://github.com/$CCT_MODULES_FORK/cct_module"
  git clone -b $CCT_MODULES_TAG http://github.com/$CCT_MODULES_FORK/cct_module
  mkdir -p "$common_package_dir/bin/launch"
  cp cct_module/jboss/container/util/logging/bash/artifacts/opt/jboss/container/util/logging/logging.sh "$common_package_dir/bin/launch"
popd
