#!/bin/bash
SCRIPT_DIR=$(dirname $0)
wildflyPath=$1
nobuild=$2
buildImageDir=$SCRIPT_DIR/../wildfly-builder-image
overridesFile=$buildImageDir/dev-overrides.yaml
generatorJar=$SCRIPT_DIR/maven-repo-generator/target/maven-repo-generator-1.0.jar

if [ ! -d "$wildflyPath" ]; then
  echo "ERROR: WildFly directory doesn't exist."
  exit 1
fi

if [ -z "$nobuild" ] || [ ! "$nobuild" = "--no-wildfly-build" ]; then
  mvn -f $wildflyPath/pom.xml clean install -DskipTests -Drelease
  if [ $? != 0 ]; then
    echo ERROR: Building WildFly failed.
    exit 1
  fi
fi

offliner=$(find $wildflyPath/dist/target/ -type f -iname "*-all-artifacts-list.txt")

if [ ! -f "$offliner" ]; then
  echo ERROR: Offliner file not found in  $wildflyPath/dist/target/ be sure to build WildFly with -Drelease argument
  exit 1
fi

if [ ! -f "$generatorJar" ]; then
  mvn -f $SCRIPT_DIR/maven-repo-generator/pom.xml clean package
  if [ $? != 0 ]; then
    echo ERROR: Building repo generator failed.
    exit 1
  fi
fi

java -jar $generatorJar $offliner
if [ $? != 0 ]; then
  echo ERROR: Building maven repo failed.
  exit 1
fi

pushd $buildImageDir
  cekit build --overrides=$overridesFile docker
  if [ $? != 0 ]; then
    echo ERROR: Building image failed.
  fi
popd
rm -rf maven-repo.zip
rm -f errors.log
