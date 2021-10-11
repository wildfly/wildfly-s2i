#!/bin/bash
SCRIPT_DIR=$(dirname $0)
wildflyPath=$1
nobuild=$2
buildImageDir=$SCRIPT_DIR/../wildfly-builder-image
modulesDir=$SCRIPT_DIR/../wildfly-modules
customModule=$modulesDir/jboss/container/wildfly/base/custom/module.yaml
customModuleCopy=$modulesDir/jboss/container/wildfly/base/custom/module.yaml.orig
overridesFile=$buildImageDir/dev-overrides.yaml
generatorJar=$SCRIPT_DIR/maven-repo-generator/target/maven-repo-generator-1.0.jar
buildEngine=docker

if [ ! -d "$wildflyPath" ]; then
  echo "ERROR: WildFly directory doesn't exist."
  exit 1
fi

if [ -z "$nobuild" ] || [ ! "$nobuild" = "--no-wildfly-build" ]; then
  mvn -f $wildflyPath/pom.xml clean install -DskipTests
  if [ $? != 0 ]; then
    echo ERROR: Building WildFly failed.
    exit 1
  fi
fi

wildflyDir=$(find $wildflyPath/dist/target/ -type d -iname "wildfly-*")
if [ ! -d "$wildflyDir" ]; then
  echo ERROR: WildFly installation directory not found in  $wildflyPath/dist/target/ be sure to build WildFly
  exit 1
fi

version="$(basename $wildflyDir)"
version="${version#wildfly-}"

cloudFpPath="${SCRIPT_DIR}/../wildfly-cloud-legacy-galleon-pack"
cloudFpPathCopy=/tmp/wildfly-cloud-legacy-galleon-pack
rm -rf "${cloudFpPathCopy}"
cp -r "${cloudFpPath}" /tmp

pushd "${cloudFpPathCopy}" > /dev/null
  mvn versions:set -DnewVersion=$version
popd > /dev/null

mvn -f "${cloudFpPathCopy}"/pom.xml clean install -Drelease -Dversion.org.wildfly=$version

offliner=$(find "${cloudFpPathCopy}/release/target/" -type f -iname "*-all-artifacts-list.txt")
if [ ! -f "$offliner" ]; then
  echo ERROR: Offliner file not found in  $cloudFpPathCopy/release/target/
  exit 1
fi

echo "Building image for Wildfly $version"

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
# Replace the placeholders in $customModule with $version
if [[ "$OSTYPE" == "darwin"* ]]; then
  # OS X - has a different sed syntax
  sed -i "" -e "s|###WILDFLY_SNAPSHOT_VERSION###|$version|" "$customModule"
  sed -i "" -e "s|###CLOUD_SNAPSHOT_VERSION###|$version|" "$customModule"
else
  # Standard Linux bash sed syntax
  sed -i "s|###WILDFLY_SNAPSHOT_VERSION###|$version|" "$customModule"
  sed -i "s|###CLOUD_SNAPSHOT_VERSION###|$version|" "$customModule"
fi
echo "Patched $customModule with proper version $version"

pushd $buildImageDir > /dev/null
  cekit build --overrides=$overridesFile ${buildEngine}
  if [ $? != 0 ]; then
    echo ERROR: Building image failed.
  fi
popd > /dev/null

mv $customModuleCopy $customModule
echo "Reverted changes done to $customModule"
rm -rf /tmp/maven-repo.zip
echo "/tmp/maven-repo.zip deleted"
rm -rf "${cloudFpPathCopy}"
echo "${cloudFpPathCopy} deleted"
rm -f errors.log
echo "Done!"
