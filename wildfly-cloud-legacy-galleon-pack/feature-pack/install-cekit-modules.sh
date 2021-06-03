#!/bin/sh
# Install launch scripts.
SCRIPT_DIR=$(pwd -P)/$(dirname $0)
tmp_dir="$SCRIPT_DIR/target/tmp"
resources_dir="$SCRIPT_DIR/target/resources"
packages_dir="$resources_dir/packages"
common_package_dir="$packages_dir/wildfly.s2i.common/content"

mkdir -p $common_package_dir
mkdir -p $tmp_dir
pushd "$tmp_dir"
  git clone -b $WILDFLY_CEKIT_TAG http://github.com/$WILDFLY_CEKIT_FORK/wildfly-cekit-modules 
  export JBOSS_HOME="$common_package_dir"
  mkdir -p "$JBOSS_HOME/bin/launch"
  pushd wildfly-cekit-modules/jboss/container/wildfly/launch
    for f in *; do
      if [ -d "$f" ]; then
        pushd "$f"
          if [ -f "./configure.sh" ]; then
            sh ./configure.sh
          else
            # Single case, node-name
            if [ -d "node-name" ]; then
              pushd node-name
                sh ./configure.sh
              popd
            else
              echo Missing configure.sh for "$f"
              exit 1;
            fi
          fi
        popd
      fi
    done
  popd
  pushd wildfly-cekit-modules/jboss/container/wildfly/launch-config
    for f in *; do
      if [ -d "$f" ]; then
        pushd "$f"
          if [ -f "./configure.sh" ]; then
            sh ./configure.sh
          else
            echo Missing configure.sh for "$f"
            exit 1;
          fi
        popd
      fi
    done
  popd
  pushd wildfly-cekit-modules/jboss/container/wildfly/galleon/fp-content
    pushd ejb-tx-recovery/added/src/main/resources
      cp -r * "$resources_dir"
    popd
    pushd java/added/src/main/resources
      cp -r * "$resources_dir"
    popd
    pushd jolokia/added/src/main/resources
      cp -r * "$resources_dir"
    popd
    pushd keycloak/added/src/main/resources
      cp -r * "$resources_dir"
    popd
    pushd config/added/src/main/resources
      cp -r * "$resources_dir"
    popd
  popd
popd
unset JBOSS_HOME
