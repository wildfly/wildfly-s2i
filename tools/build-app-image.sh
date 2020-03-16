#!/bin/bash
SCRIPT_DIR=$(dirname $0)
appPath=$1

if [ ! -d "$appPath" ]; then
  echo "ERROR: Application directory doesn't exist."
  exit 1
fi

build_chained_build() {
  rt_docker_dir=$(mktemp -d)
  rt_docker_file=$rt_docker_dir/Dockerfile
  cat <<EOF > $rt_docker_file
FROM $wildflyRuntimeImage
COPY --from=$appS2iImage:latest /s2i-output/server \$JBOSS_HOME
USER root
RUN chown -R jboss:root \$JBOSS_HOME && chmod -R ug+rwX \$JBOSS_HOME
RUN ln -s \$JBOSS_HOME /wildfly
USER jboss
CMD \$JBOSS_HOME/bin/openshift-launch.sh
EOF
  docker build -t $appImage $rt_docker_dir
  ret=$?
  rm -rf $rt_docker_dir
  return $ret
}


shift

for i in "$@"
do
case $i in
    --app-name=*)
    appName="${i#*=}"
    shift
    ;;
    --galleon-layers=*)
    galleonLayers="${i#*=}"
    shift
    ;;
    --wildfly-builder-image=*)
    wildflyImage="${i#*=}"
    shift
    ;;
    --wildfly-runtime-image=*)
    wildflyRuntimeImage="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

if [ -z "$wildflyImage" ]; then
  wildflyImage=quay.io/wildfly/wildfly-builder:latest
fi

if [ -z "$wildflyRuntimeImage" ]; then
  wildflyRuntimeImage=quay.io/wildfly/wildfly-runtime:latest
fi

if [ -z "$appName" ]; then
  appName=$(basename $appPath)
fi

appS2iImage=$appName-s2i-img
appImage=$appName

s2i --loglevel 1 build -e GALLEON_PROVISION_DEFAULT_FAT_SERVER=true -e GALLEON_PROVISION_LAYERS=$galleonLayers $appPath $wildflyImage $appS2iImage

if [ $? != 0 ]; then
  echo ERROR: s2i build failed.
  exit 1
fi

build_chained_build

if [ $? != 0 ]; then
  echo ERROR: docker multi stages build failed.
  exit 1
fi