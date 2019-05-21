#!/bin/sh
# Configure module
set -e
SCRIPT_DIR=$(dirname $0)

# required to have maven enabled.
source $JBOSS_CONTAINER_MAVEN_35_MODULE/scl-enable-maven

# Provision the default server
DEFAULT_SERVER=os-standalone-profile

# The active profiles are jboss-community-repository and securecentral
mvn -f $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/pom.xml package -Dmaven.repo.local=$MAVEN_LOCAL_REPO \
-Dcom.redhat.xpaas.repo.jbossorg --settings $HOME/.m2/settings.xml

# Install WildFly server
rm -rf $JBOSS_HOME
cp -r $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/target/wildfly $JBOSS_HOME
rm -r $JBOSS_CONTAINER_WILDFLY_GALLEON_DEFINITIONS/$DEFAULT_SERVER/target
ln -s $JBOSS_HOME /wildfly

# link deployments
cp -r $JBOSS_HOME/standalone/deployments/* /deployments
rm -rf $JBOSS_HOME/standalone/deployments
ln -s /deployments $JBOSS_HOME/standalone/deployments

chown -R jboss:root $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME 
chown -R jboss:root $HOME
chmod -R ug+rwX $MAVEN_LOCAL_REPO
