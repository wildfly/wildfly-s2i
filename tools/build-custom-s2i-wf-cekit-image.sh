#!/bin/bash
SCRIPT_DIR=$(dirname $0)
version=$1
cekitFork=$2
cekitBranch=$3
buildImageDir=$SCRIPT_DIR/../wildfly-builder-image
modulesDir=$SCRIPT_DIR/../wildfly-modules
customModule=$modulesDir/jboss/container/wildfly/base/custom/module.yaml
customModuleCopy=$modulesDir/jboss/container/wildfly/base/custom/module.yaml.orig
overridesFile=$buildImageDir/custom-wf-cekit-modules.yaml
generatorJar=$SCRIPT_DIR/maven-repo-generator/target/maven-repo-generator-1.0.jar
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

cloudFpPath="${SCRIPT_DIR}/../wildfly-cloud-legacy-galleon-pack"
cloudFpPathCopy=/tmp/wildfly-cloud-legacy-galleon-pack
rm -rf "${cloudFpPathCopy}"
cp -r "${cloudFpPath}" /tmp

pushd "${cloudFpPathCopy}"
mvn versions:set -DnewVersion=$version
#Retrieve WildFly version
wildflyVersion=$(mvn help:evaluate -Dexpression=version.org.wildfly -q -DforceStdout)
#Build cloud fp
mvn clean install -Dwildfly.cekit.modules.tag=$cekitBranch -Dwildfly.cekit.modules.fork=$cekitFork -Drelease

popd

offliner=$(find "${cloudFpPathCopy}/release/target/" -type f -iname "*-all-artifacts-list.txt")
if [ ! -f "$offliner" ]; then
  echo ERROR: Offliner file not found in  $cloudFpPathCopy/release/target/
  exit 1
fi

if [ ! -f "$generatorJar" ]; then
  mvn -f $SCRIPT_DIR/maven-repo-generator/pom.xml clean package
  if [ $? != 0 ]; then
    echo ERROR: Building repo generator failed.
    exit 1
  fi
fi

echo "Generating zipped maven repository"
java -jar $generatorJar $offliner > /dev/null 2>&1 
if [ $? != 0 ]; then
  echo ERROR: Building maven repo failed.
  exit 1
fi
mv maven-repo.zip /tmp
echo "Zipped maven repository generated in /tmp/maven-repo.zip"

cp "$customModule" "$customModuleCopy"
sed -i "s|###WILDFLY_SNAPSHOT_VERSION###|$wildflyVersion|" "$customModule"
sed -i "s|###CLOUD_SNAPSHOT_VERSION###|$version|" "$customModule"
echo "Patched $customModule with proper version $version"

pushd $buildImageDir
cekit build --overrides=$overridesFile ${buildEngine}
if [ $? != 0 ]; then
  echo ERROR: Building image failed.
fi
popd

mv $customModuleCopy $customModule
echo "Reverted changes done to $customModule"
rm -rf /tmp/maven-repo.zip
echo "/tmp/maven-repo.zip deleted"
rm -rf "${cloudFpPathCopy}"
echo "${cloudFpPathCopy} deleted"
rm -f errors.log
echo "Done!"
