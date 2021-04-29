#!/bin/bash
SCRIPT_DIR=$(dirname $0)
version=$1
cekitFork=$2
cekitBranch=$3
buildImageDir=$SCRIPT_DIR/../wildfly-builder-image
overridesFile=$buildImageDir/custom-wf-cekit-modules.yaml
buildEngine=docker

sed -i "s|###IMG_VERSION###|$version|" "$overridesFile"
sed -i "s|###FORK_NAME###|$cekitFork|" "$overridesFile"
sed -i "s|###CEKIT_BRANCH###|$cekitBranch|" "$overridesFile"

echo Using overrides file content:
echo #########################
echo
cat $overridesFile
echo
echo #########################

cd $buildImageDir
  cekit build --overrides=$overridesFile ${buildEngine}
  if [ $? != 0 ]; then
    echo ERROR: Building image failed.
    exit 1
  fi
cd $SCRIPT_DIR

echo "Done!"
