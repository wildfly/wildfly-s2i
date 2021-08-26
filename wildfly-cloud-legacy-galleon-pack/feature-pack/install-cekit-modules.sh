#!/bin/bash
set -e
# Install launch scripts.
SCRIPT_DIR=$(pwd -P)/$(dirname $0)
tmp_dir="$SCRIPT_DIR/target/tmp"
resources_dir="$SCRIPT_DIR/target/resources"
packages_dir="$resources_dir/packages"
common_package_dir="$packages_dir/wildfly.s2i.common/content"
fp_content_list_file=$SCRIPT_DIR/wf-cekit-modules-fp-content-list.txt
launch_list_file=$SCRIPT_DIR/wf-cekit-modules-launch-list.txt

mkdir -p $common_package_dir
mkdir -p $tmp_dir
pushd "$tmp_dir" > /dev/null
  echo "git clone -b $WILDFLY_CEKIT_TAG http://github.com/$WILDFLY_CEKIT_FORK/wildfly-cekit-modules"
  git clone -b $WILDFLY_CEKIT_TAG http://github.com/$WILDFLY_CEKIT_FORK/wildfly-cekit-modules 
  export JBOSS_HOME="$common_package_dir"
  mkdir -p "$JBOSS_HOME/bin/launch"
  pushd wildfly-cekit-modules/jboss/container/wildfly/launch > /dev/null
    while read dir; do
      dir="${dir//.//}"
      if [ -d "$dir" ]; then
        echo Adding launch scripts from $dir
        pushd "$dir" > /dev/null
          if [ -f "./configure.sh" ]; then
            sh ./configure.sh
          else
            echo Missing configure.sh for "$dir"
            exit 1
          fi
        popd > /dev/null
      else
        echo invalid directory $dir
        exit 1
      fi
    done < $launch_list_file
  popd > /dev/null
  pushd wildfly-cekit-modules/jboss/container/wildfly/launch-config > /dev/null
    for f in *; do
      if [ -d "$f" ]; then
        echo Adding launch config files from $f
        pushd "$f" > /dev/null
          if [ -f "./configure.sh" ]; then
            sh ./configure.sh
          else
            echo Missing configure.sh for "$f"
            exit 1;
          fi
        popd > /dev/null
      fi
    done
  popd > /dev/null
  pushd wildfly-cekit-modules/jboss/container/wildfly/galleon/fp-content > /dev/null
   while read dir; do
     echo Adding feature-content from $dir
     pushd $dir/added/src/main/resources > /dev/null
      cp -r * "$resources_dir"
     popd > /dev/null
   done < $fp_content_list_file
  popd > /dev/null
popd > /dev/null
unset JBOSS_HOME
